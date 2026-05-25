package repository

import (
	"context"
	"errors"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
	"library-management/internal/models"
)

type EmployeeRepo struct {
	db *pgxpool.Pool
}

func NewEmployeeRepo(db *pgxpool.Pool) *EmployeeRepo {
	return &EmployeeRepo{db: db}
}

func (r *EmployeeRepo) GetByID(ctx context.Context, id int) (*models.Employee, error) {
	var emp models.Employee
	err := r.db.QueryRow(ctx, `
		SELECT id, library_id, reading_room_id, first_name, last_name
		FROM employee WHERE id = $1
	`, id).Scan(&emp.ID, &emp.LibraryID, &emp.ReadingRoomID, &emp.FirstName, &emp.LastName)
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, nil
	}
	return &emp, err
}

func (r *EmployeeRepo) ListByReadingRoom(ctx context.Context, libraryID, readingRoomID int) ([]models.Employee, error) {
	rows, err := r.db.Query(ctx, `
		SELECT id, library_id, reading_room_id, first_name, last_name
		FROM employee WHERE library_id = $1 AND reading_room_id = $2
	`, libraryID, readingRoomID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var employees []models.Employee
	for rows.Next() {
		var e models.Employee
		if err := rows.Scan(&e.ID, &e.LibraryID, &e.ReadingRoomID, &e.FirstName, &e.LastName); err != nil {
			return nil, err
		}
		employees = append(employees, e)
	}
	return employees, nil
}

// GetFreeEmployeeID возвращает ID сотрудника, который ещё не привязан к пользователю
func (r *EmployeeRepo) GetFreeEmployeeID(ctx context.Context) (int, error) {
	var id int
	err := r.db.QueryRow(ctx, `
		SELECT id FROM employee 
		WHERE id NOT IN (SELECT employee_id FROM users WHERE employee_id IS NOT NULL)
		LIMIT 1
	`).Scan(&id)
	if err != nil {
		return 0, err
	}
	return id, nil
}
