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

type CopyHandler struct {
	pubRepo *repository.PublicationRepo
}

func NewCopyHandler(repo *repository.PublicationRepo) *CopyHandler {
	return &CopyHandler{pubRepo: repo}
}

// CreateCopy POST /api/copies
func (h *CopyHandler) CreateCopy(w http.ResponseWriter, r *http.Request) {
	var req struct {
		InventoryNumber    int       `json:"inventory_number"`
		PublicationID      int       `json:"publication_id"`
		ShelfID            int       `json:"shelf_id"`
		ReceiptDate        time.Time `json:"receipt_date"`
		ReceivedEmployeeID int       `json:"received_employee_id"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request", http.StatusBadRequest)
		return
	}
	copy := &models.PublicationCopy{
		InventoryNumber:    req.InventoryNumber,
		PublicationID:      req.PublicationID,
		ShelfID:            req.ShelfID,
		ReceiptDate:        req.ReceiptDate,
		ReceivedEmployeeID: req.ReceivedEmployeeID,
	}
	err := h.pubRepo.CreateCopy(r.Context(), copy)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	w.WriteHeader(http.StatusCreated)
}

// GetCopy GET /api/copies/{inventory_number}
func (h *CopyHandler) GetCopy(w http.ResponseWriter, r *http.Request) {
	invStr := chi.URLParam(r, "inventory_number")
	inv, err := strconv.Atoi(invStr)
	if err != nil {
		http.Error(w, "Invalid inventory number", http.StatusBadRequest)
		return
	}
	copy, err := h.pubRepo.GetCopyByInventoryNumber(r.Context(), inv)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	if copy == nil {
		http.Error(w, "Not found", http.StatusNotFound)
		return
	}
	json.NewEncoder(w).Encode(copy)
}

// UpdateCopy PUT /api/copies/{inventory_number}
func (h *CopyHandler) UpdateCopy(w http.ResponseWriter, r *http.Request) {
	invStr := chi.URLParam(r, "inventory_number")
	inv, err := strconv.Atoi(invStr)
	if err != nil {
		http.Error(w, "Invalid inventory number", http.StatusBadRequest)
		return
	}
	var req struct {
		ShelfID            int `json:"shelf_id"`
		ReceivedEmployeeID int `json:"received_employee_id"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request", http.StatusBadRequest)
		return
	}
	err = h.pubRepo.UpdateCopy(r.Context(), inv, req.ShelfID, req.ReceivedEmployeeID)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	w.WriteHeader(http.StatusOK)
}

// DeleteCopy DELETE /api/copies/{inventory_number}
func (h *CopyHandler) DeleteCopy(w http.ResponseWriter, r *http.Request) {
	invStr := chi.URLParam(r, "inventory_number")
	inv, err := strconv.Atoi(invStr)
	if err != nil {
		http.Error(w, "Invalid inventory number", http.StatusBadRequest)
		return
	}
	// Проверка активных выдач
	active, err := h.pubRepo.HasActiveLoans(r.Context(), inv)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	if active {
		http.Error(w, "Cannot delete copy: it is on loan", http.StatusConflict)
		return
	}
	err = h.pubRepo.DeleteCopy(r.Context(), inv)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	w.WriteHeader(http.StatusNoContent)
}

// WriteOffCopy POST /api/copies/{inventory_number}/write-off
func (h *CopyHandler) WriteOffCopy(w http.ResponseWriter, r *http.Request) {
	invStr := chi.URLParam(r, "inventory_number")
	inv, err := strconv.Atoi(invStr)
	if err != nil {
		http.Error(w, "Invalid inventory number", http.StatusBadRequest)
		return
	}
	var req struct {
		EmployeeID int `json:"write_off_employee_id"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request", http.StatusBadRequest)
		return
	}
	if req.EmployeeID == 0 {
		http.Error(w, "write_off_employee_id required", http.StatusBadRequest)
		return
	}
	err = h.pubRepo.WriteOffCopy(r.Context(), inv, req.EmployeeID)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	w.WriteHeader(http.StatusOK)
}
