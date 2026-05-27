package handler

import (
	"encoding/json"
	"library-management/internal/repository"
	"net/http"
	"strconv"
	"time"
)

type QueryHandler struct {
	queryRepo *repository.QueryRepo
}

func NewQueryHandler(qr *repository.QueryRepo) *QueryHandler {
	return &QueryHandler{queryRepo: qr}
}

// 1. GET /api/queries/readers-by-attribute?category_id=1&attr_name=University&attr_value=MSU
func (h *QueryHandler) GetReadersByAttribute(w http.ResponseWriter, r *http.Request) {
	categoryID, _ := strconv.Atoi(r.URL.Query().Get("category_id"))
	attrName := r.URL.Query().Get("attr_name")
	attrValue := r.URL.Query().Get("attr_value")
	if categoryID == 0 || attrName == "" || attrValue == "" {
		http.Error(w, "Missing parameters: category_id, attr_name, attr_value", http.StatusBadRequest)
		return
	}
	res, err := h.queryRepo.GetReadersByAttribute(r.Context(), categoryID, attrName, attrValue)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	json.NewEncoder(w).Encode(res)
}

// 2. GET /api/queries/readers-by-work-on-hands?work_id=1
func (h *QueryHandler) GetReadersByWorkOnHands(w http.ResponseWriter, r *http.Request) {
	workID, _ := strconv.Atoi(r.URL.Query().Get("work_id"))
	if workID == 0 {
		http.Error(w, "Missing work_id", http.StatusBadRequest)
		return
	}
	res, err := h.queryRepo.GetReadersByWorkOnHands(r.Context(), workID)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	json.NewEncoder(w).Encode(res)
}

// 3. GET /api/queries/readers-by-publication-on-hands?publication_id=1
func (h *QueryHandler) GetReadersByPublicationOnHands(w http.ResponseWriter, r *http.Request) {
	pubID, _ := strconv.Atoi(r.URL.Query().Get("publication_id"))
	if pubID == 0 {
		http.Error(w, "Missing publication_id", http.StatusBadRequest)
		return
	}
	res, err := h.queryRepo.GetReadersByPublicationOnHands(r.Context(), pubID)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	json.NewEncoder(w).Encode(res)
}

// 4. GET /api/queries/readers-by-work-in-period?work_id=1&date_from=2024-01-01&date_to=2024-12-31
func (h *QueryHandler) GetReadersByWorkInPeriod(w http.ResponseWriter, r *http.Request) {
	workID, _ := strconv.Atoi(r.URL.Query().Get("work_id"))
	dateFromStr := r.URL.Query().Get("date_from")
	dateToStr := r.URL.Query().Get("date_to")
	if workID == 0 || dateFromStr == "" || dateToStr == "" {
		http.Error(w, "Missing work_id, date_from, date_to", http.StatusBadRequest)
		return
	}
	dateFrom, err := time.Parse("2006-01-02", dateFromStr)
	if err != nil {
		http.Error(w, "Invalid date_from format, use YYYY-MM-DD", http.StatusBadRequest)
		return
	}
	dateTo, err := time.Parse("2006-01-02", dateToStr)
	if err != nil {
		http.Error(w, "Invalid date_to format, use YYYY-MM-DD", http.StatusBadRequest)
		return
	}
	res, err := h.queryRepo.GetReadersByWorkInPeriod(r.Context(), workID, dateFrom, dateTo)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	json.NewEncoder(w).Encode(res)
}

// 5. GET /api/queries/publications-from-own-library?reader_id=1&date_from=2024-01-01&date_to=2024-12-31
func (h *QueryHandler) GetPublicationsFromOwnLibrary(w http.ResponseWriter, r *http.Request) {
	readerID, _ := strconv.Atoi(r.URL.Query().Get("reader_id"))
	dateFromStr := r.URL.Query().Get("date_from")
	dateToStr := r.URL.Query().Get("date_to")
	if readerID == 0 || dateFromStr == "" || dateToStr == "" {
		http.Error(w, "Missing reader_id, date_from, date_to", http.StatusBadRequest)
		return
	}
	dateFrom, _ := time.Parse("2006-01-02", dateFromStr)
	dateTo, _ := time.Parse("2006-01-02", dateToStr)
	res, err := h.queryRepo.GetPublicationsFromOwnLibrary(r.Context(), readerID, dateFrom, dateTo)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	json.NewEncoder(w).Encode(res)
}

// 6. GET /api/queries/publications-from-other-library?reader_id=1&date_from=2024-01-01&date_to=2024-12-31
func (h *QueryHandler) GetPublicationsFromOtherLibrary(w http.ResponseWriter, r *http.Request) {
	readerID, _ := strconv.Atoi(r.URL.Query().Get("reader_id"))
	dateFromStr := r.URL.Query().Get("date_from")
	dateToStr := r.URL.Query().Get("date_to")
	if readerID == 0 || dateFromStr == "" || dateToStr == "" {
		http.Error(w, "Missing reader_id, date_from, date_to", http.StatusBadRequest)
		return
	}
	dateFrom, _ := time.Parse("2006-01-02", dateFromStr)
	dateTo, _ := time.Parse("2006-01-02", dateToStr)
	res, err := h.queryRepo.GetPublicationsFromOtherLibrary(r.Context(), readerID, dateFrom, dateTo)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	json.NewEncoder(w).Encode(res)
}

// 7. GET /api/queries/loaned-from-shelf?shelf_id=1
func (h *QueryHandler) GetLoanedFromShelf(w http.ResponseWriter, r *http.Request) {
	shelfID, _ := strconv.Atoi(r.URL.Query().Get("shelf_id"))
	if shelfID == 0 {
		http.Error(w, "Missing shelf_id", http.StatusBadRequest)
		return
	}
	res, err := h.queryRepo.GetLoanedFromShelf(r.Context(), shelfID)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	json.NewEncoder(w).Encode(res)
}

// 8. GET /api/queries/readers-served-by-employee?employee_id=1&date_from=2024-01-01&date_to=2024-12-31
func (h *QueryHandler) GetReadersServedByEmployee(w http.ResponseWriter, r *http.Request) {
	empID, _ := strconv.Atoi(r.URL.Query().Get("employee_id"))
	dateFromStr := r.URL.Query().Get("date_from")
	dateToStr := r.URL.Query().Get("date_to")
	if empID == 0 || dateFromStr == "" || dateToStr == "" {
		http.Error(w, "Missing employee_id, date_from, date_to", http.StatusBadRequest)
		return
	}
	dateFrom, _ := time.Parse("2006-01-02", dateFromStr)
	dateTo, _ := time.Parse("2006-01-02", dateToStr)
	res, err := h.queryRepo.GetReadersServedByEmployee(r.Context(), empID, dateFrom, dateTo)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	json.NewEncoder(w).Encode(res)
}

// 9. GET /api/queries/employee-workload?date_from=2024-01-01&date_to=2024-12-31
func (h *QueryHandler) GetEmployeeWorkload(w http.ResponseWriter, r *http.Request) {
	dateFromStr := r.URL.Query().Get("date_from")
	dateToStr := r.URL.Query().Get("date_to")
	if dateFromStr == "" || dateToStr == "" {
		http.Error(w, "Missing date_from, date_to", http.StatusBadRequest)
		return
	}
	dateFrom, _ := time.Parse("2006-01-02", dateFromStr)
	dateTo, _ := time.Parse("2006-01-02", dateToStr)
	res, err := h.queryRepo.GetEmployeeWorkload(r.Context(), dateFrom, dateTo)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	json.NewEncoder(w).Encode(res)
}

// 10. GET /api/queries/readers-with-overdue
func (h *QueryHandler) GetReadersWithOverdue(w http.ResponseWriter, r *http.Request) {
	res, err := h.queryRepo.GetReadersWithOverdue(r.Context())
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	json.NewEncoder(w).Encode(res)
}

// 11. GET /api/queries/copy-movements?date_from=2024-01-01&date_to=2024-12-31
func (h *QueryHandler) GetCopyMovements(w http.ResponseWriter, r *http.Request) {
	dateFromStr := r.URL.Query().Get("date_from")
	dateToStr := r.URL.Query().Get("date_to")
	if dateFromStr == "" || dateToStr == "" {
		http.Error(w, "Missing date_from, date_to", http.StatusBadRequest)
		return
	}
	dateFrom, _ := time.Parse("2006-01-02", dateFromStr)
	dateTo, _ := time.Parse("2006-01-02", dateToStr)
	res, err := h.queryRepo.GetCopyMovements(r.Context(), dateFrom, dateTo)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	json.NewEncoder(w).Encode(res)
}

// 12. GET /api/queries/employees-by-reading-room?library_id=1&reading_room_id=1
func (h *QueryHandler) GetEmployeesByReadingRoom(w http.ResponseWriter, r *http.Request) {
	libID, _ := strconv.Atoi(r.URL.Query().Get("library_id"))
	roomID, _ := strconv.Atoi(r.URL.Query().Get("reading_room_id"))
	if libID == 0 || roomID == 0 {
		http.Error(w, "Missing library_id, reading_room_id", http.StatusBadRequest)
		return
	}
	res, err := h.queryRepo.GetEmployeesByReadingRoom(r.Context(), libID, roomID)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	json.NewEncoder(w).Encode(res)
}

// 13. GET /api/queries/inactive-readers?date_from=2024-01-01&date_to=2024-12-31
func (h *QueryHandler) GetInactiveReaders(w http.ResponseWriter, r *http.Request) {
	dateFromStr := r.URL.Query().Get("date_from")
	dateToStr := r.URL.Query().Get("date_to")
	if dateFromStr == "" || dateToStr == "" {
		http.Error(w, "Missing date_from, date_to", http.StatusBadRequest)
		return
	}
	dateFrom, _ := time.Parse("2006-01-02", dateFromStr)
	dateTo, _ := time.Parse("2006-01-02", dateToStr)
	res, err := h.queryRepo.GetInactiveReaders(r.Context(), dateFrom, dateTo)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	json.NewEncoder(w).Encode(res)
}

// 14. GET /api/queries/copies-by-work?work_id=1
func (h *QueryHandler) GetCopiesByWork(w http.ResponseWriter, r *http.Request) {
	workID, _ := strconv.Atoi(r.URL.Query().Get("work_id"))
	if workID == 0 {
		http.Error(w, "Missing work_id", http.StatusBadRequest)
		return
	}
	res, err := h.queryRepo.GetCopiesByWork(r.Context(), workID)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	json.NewEncoder(w).Encode(res)
}

// 15. GET /api/queries/copies-by-author?author_id=1
func (h *QueryHandler) GetCopiesByAuthor(w http.ResponseWriter, r *http.Request) {
	authorID, _ := strconv.Atoi(r.URL.Query().Get("author_id"))
	if authorID == 0 {
		http.Error(w, "Missing author_id", http.StatusBadRequest)
		return
	}
	res, err := h.queryRepo.GetCopiesByAuthor(r.Context(), authorID)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	json.NewEncoder(w).Encode(res)
}

// 16. GET /api/queries/popular-works
func (h *QueryHandler) GetPopularWorks(w http.ResponseWriter, r *http.Request) {
	res, err := h.queryRepo.GetPopularWorks(r.Context())
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	json.NewEncoder(w).Encode(res)
}
