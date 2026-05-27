package repository

import (
	"context"
	"errors"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
	"library-management/internal/models"
)

type UserRepo struct {
	db *pgxpool.Pool
}

func NewUserRepo(db *pgxpool.Pool) *UserRepo {
	return &UserRepo{db: db}
}

func (r *UserRepo) Create(ctx context.Context, user *models.User) (int, error) {
	var id int
	err := r.db.QueryRow(ctx, `
		INSERT INTO users (login, password_hash, role, reader_id, employee_id)
		VALUES ($1, $2, $3, $4, $5) RETURNING id
	`, user.Login, user.PasswordHash, user.Role, user.ReaderID, user.EmployeeID).Scan(&id)
	return id, err
}

func (r *UserRepo) GetByLogin(ctx context.Context, login string) (*models.User, error) {
	var u models.User
	err := r.db.QueryRow(ctx, `
		SELECT id, login, password_hash, role, reader_id, employee_id, created_at
		FROM users WHERE login = $1
	`, login).Scan(&u.ID, &u.Login, &u.PasswordHash, &u.Role, &u.ReaderID, &u.EmployeeID, &u.CreatedAt)
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, nil
	}
	return &u, err
}
