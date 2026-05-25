package models

import "time"

type User struct {
	ID           int       `json:"id"`
	Login        string    `json:"login"`
	PasswordHash string    `json:"-"`
	Role         string    `json:"role"`
	ReaderID     *int      `json:"reader_id,omitempty"`
	EmployeeID   *int      `json:"employee_id,omitempty"`
	CreatedAt    time.Time `json:"created_at"`
}

type LoginRequest struct {
	Login    string `json:"login"`
	Password string `json:"password"`
}

type RegisterRequest struct {
	Login      string `json:"login"`
	Password   string `json:"password"`
	Role       string `json:"role"`
	ReaderID   *int   `json:"reader_id,omitempty"`
	EmployeeID *int   `json:"employee_id,omitempty"`
}

type LoginResponse struct {
	Token       string `json:"token"`
	Role        string `json:"role"`
	ReaderID    *int   `json:"reader_id,omitempty"`
	EmployeeID  *int   `json:"employee_id,omitempty"`
	FirstName   string `json:"first_name,omitempty"`
	LastName    string `json:"last_name,omitempty"`
	LibraryName string `json:"library_name,omitempty"`
}
