package repository

import (
	"context"
	"errors"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
	"library-management/internal/models"
)

type LoanRepo struct {
	db *pgxpool.Pool
}

func NewLoanRepo(db *pgxpool.Pool) *LoanRepo {
	return &LoanRepo{db: db}
}

// CreateLoan – выдача книги (на руки)
func (r *LoanRepo) CreateLoan(ctx context.Context, loan *models.Loan) (int, error) {
	var id int
	err := r.db.QueryRow(ctx, `
		INSERT INTO loans (reader_id, copy_inventory_number, date_of_issue, return_date, expire_date, issued_employee_id)
		VALUES ($1, $2, $3, $4, $5, $6) RETURNING id
	`, loan.ReaderID, loan.CopyInventoryNumber, loan.DateOfIssue, loan.ReturnDate, loan.ExpireDate, loan.IssuedEmployeeID).Scan(&id)
	return id, err
}

// ReturnLoan – возврат книги (устанавливаем return_date)
func (r *LoanRepo) ReturnLoan(ctx context.Context, loanID int, returnDate time.Time) error {
	_, err := r.db.Exec(ctx, `
		UPDATE loans SET return_date = $1 WHERE id = $2 AND return_date IS NULL
	`, returnDate, loanID)
	return err
}

// GetActiveLoansByReader – текущие выдачи читателя (не возвращённые)
func (r *LoanRepo) GetActiveLoansByReader(ctx context.Context, readerID int) ([]models.Loan, error) {
	rows, err := r.db.Query(ctx, `
		SELECT id, reader_id, copy_inventory_number, date_of_issue, return_date, expire_date, issued_employee_id
		FROM loans WHERE reader_id = $1 AND return_date IS NULL
	`, readerID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var loans []models.Loan
	for rows.Next() {
		var l models.Loan
		if err := rows.Scan(&l.ID, &l.ReaderID, &l.CopyInventoryNumber, &l.DateOfIssue, &l.ReturnDate, &l.ExpireDate, &l.IssuedEmployeeID); err != nil {
			return nil, err
		}
		loans = append(loans, l)
	}
	return loans, nil
}

// GetOverdueLoans – просроченные выдачи (expire_date < current_date и return_date is null)
func (r *LoanRepo) GetOverdueLoans(ctx context.Context) ([]models.Loan, error) {
	rows, err := r.db.Query(ctx, `
		SELECT id, reader_id, copy_inventory_number, date_of_issue, return_date, expire_date, issued_employee_id
		FROM loans WHERE expire_date < CURRENT_DATE AND return_date IS NULL
	`)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var loans []models.Loan
	for rows.Next() {
		var l models.Loan
		if err := rows.Scan(&l.ID, &l.ReaderID, &l.CopyInventoryNumber, &l.DateOfIssue, &l.ReturnDate, &l.ExpireDate, &l.IssuedEmployeeID); err != nil {
			return nil, err
		}
		loans = append(loans, l)
	}
	return loans, nil
}

// IsCopyAvailable – вызывает хранимую функцию БД is_copy_available
func (r *LoanRepo) IsCopyAvailable(ctx context.Context, inventoryNumber int) (bool, error) {
	var available bool
	err := r.db.QueryRow(ctx, `SELECT is_copy_available($1)`, inventoryNumber).Scan(&available)
	return available, err
}

// GetLoanByID получает выдачу по ID
func (r *LoanRepo) GetLoanByID(ctx context.Context, id int) (*models.Loan, error) {
	var l models.Loan
	err := r.db.QueryRow(ctx, `
		SELECT id, reader_id, copy_inventory_number, date_of_issue, return_date, expire_date, issued_employee_id
		FROM loans WHERE id = $1
	`, id).Scan(&l.ID, &l.ReaderID, &l.CopyInventoryNumber, &l.DateOfIssue, &l.ReturnDate, &l.ExpireDate, &l.IssuedEmployeeID)
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, nil
	}
	return &l, err
}

// GetLoansByReader возвращает все выдачи читателя (история)
func (r *LoanRepo) GetLoansByReader(ctx context.Context, readerID int) ([]models.Loan, error) {
	rows, err := r.db.Query(ctx, `
		SELECT id, reader_id, copy_inventory_number, date_of_issue, return_date, expire_date, issued_employee_id
		FROM loans WHERE reader_id = $1 ORDER BY date_of_issue DESC
	`, readerID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var loans []models.Loan
	for rows.Next() {
		var l models.Loan
		if err := rows.Scan(&l.ID, &l.ReaderID, &l.CopyInventoryNumber, &l.DateOfIssue, &l.ReturnDate, &l.ExpireDate, &l.IssuedEmployeeID); err != nil {
			return nil, err
		}
		loans = append(loans, l)
	}
	return loans, nil
}

// GetAllActiveLoans возвращает все активные выдачи (return_date IS NULL)
func (r *LoanRepo) GetAllActiveLoans(ctx context.Context) ([]models.Loan, error) {
	rows, err := r.db.Query(ctx, `
		SELECT id, reader_id, copy_inventory_number, date_of_issue, return_date, expire_date, issued_employee_id
		FROM loans WHERE return_date IS NULL
	`)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var loans []models.Loan
	for rows.Next() {
		var l models.Loan
		if err := rows.Scan(&l.ID, &l.ReaderID, &l.CopyInventoryNumber, &l.DateOfIssue, &l.ReturnDate, &l.ExpireDate, &l.IssuedEmployeeID); err != nil {
			return nil, err
		}
		loans = append(loans, l)
	}
	return loans, nil
}

// GetAllLoans возвращает все выдачи (историю) с пагинацией
func (r *LoanRepo) GetAllLoans(ctx context.Context, limit, offset int) ([]models.Loan, error) {
	rows, err := r.db.Query(ctx, `
        SELECT id, reader_id, copy_inventory_number, date_of_issue, return_date, expire_date, issued_employee_id
        FROM loans 
        ORDER BY date_of_issue DESC 
        LIMIT $1 OFFSET $2
    `, limit, offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var loans []models.Loan
	for rows.Next() {
		var l models.Loan
		if err := rows.Scan(&l.ID, &l.ReaderID, &l.CopyInventoryNumber, &l.DateOfIssue, &l.ReturnDate, &l.ExpireDate, &l.IssuedEmployeeID); err != nil {
			return nil, err
		}
		loans = append(loans, l)
	}
	return loans, nil
}
