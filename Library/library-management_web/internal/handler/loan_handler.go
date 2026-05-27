package handler

import (
	"encoding/json"
	"github.com/go-chi/chi/v5"
	"library-management/internal/models"
	"library-management/internal/repository"
	"net/http"
	"strconv"
	"time"
)

type LoanHandler struct {
	loanRepo *repository.LoanRepo
}

func NewLoanHandler(lr *repository.LoanRepo) *LoanHandler {
	return &LoanHandler{loanRepo: lr}
}

func (h *LoanHandler) CreateLoan(w http.ResponseWriter, r *http.Request) {
	var req models.Loan
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request", http.StatusBadRequest)
		return
	}
	if req.ReaderID == 0 || req.CopyInventoryNumber == 0 || req.IssuedEmployeeID == 0 {
		http.Error(w, "reader_id, copy_inventory_number, issued_employee_id are required", http.StatusBadRequest)
		return
	}
	req.DateOfIssue = time.Now()
	id, err := h.loanRepo.CreateLoan(r.Context(), &req)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(map[string]int{"loan_id": id})
}

func (h *LoanHandler) ReturnLoan(w http.ResponseWriter, r *http.Request) {
	idStr := chi.URLParam(r, "id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		http.Error(w, "Invalid id", http.StatusBadRequest)
		return
	}
	loan, err := h.loanRepo.GetLoanByID(r.Context(), id)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	if loan == nil {
		http.Error(w, "Loan not found", http.StatusNotFound)
		return
	}
	if loan.ReturnDate != nil {
		http.Error(w, "Already returned", http.StatusBadRequest)
		return
	}
	err = h.loanRepo.ReturnLoan(r.Context(), id, time.Now())
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	w.WriteHeader(http.StatusOK)
}

func (h *LoanHandler) GetLoansByReader(w http.ResponseWriter, r *http.Request) {
	readerIDStr := chi.URLParam(r, "reader_id")
	readerID, err := strconv.Atoi(readerIDStr)
	if err != nil {
		http.Error(w, "Invalid reader_id", http.StatusBadRequest)
		return
	}
	loans, err := h.loanRepo.GetLoansByReader(r.Context(), readerID)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	json.NewEncoder(w).Encode(loans)
}

func (h *LoanHandler) GetActiveLoans(w http.ResponseWriter, r *http.Request) {
	readerIDStr := r.URL.Query().Get("reader_id")
	if readerIDStr != "" {
		readerID, _ := strconv.Atoi(readerIDStr)
		loans, err := h.loanRepo.GetActiveLoansByReader(r.Context(), readerID)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		json.NewEncoder(w).Encode(loans)
		return
	}
	loans, err := h.loanRepo.GetAllActiveLoans(r.Context())
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	json.NewEncoder(w).Encode(loans)
}

// GetAllLoans возвращает все выдачи (только для администратора)
func (h *LoanHandler) GetAllLoans(w http.ResponseWriter, r *http.Request) {
	limit, err := strconv.Atoi(r.URL.Query().Get("limit"))
	if err != nil || limit <= 0 {
		limit = 100
	}
	offset, err := strconv.Atoi(r.URL.Query().Get("offset"))
	if err != nil {
		offset = 0
	}
	loans, err := h.loanRepo.GetAllLoans(r.Context(), limit, offset)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	json.NewEncoder(w).Encode(loans)
}
