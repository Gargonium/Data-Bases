package models

import "time"

type Reader struct {
	ID               int       `json:"id"`
	CategoryID       int       `json:"category_id"`
	LibraryID        int       `json:"library_id"`
	FirstName        string    `json:"first_name"`
	LastName         string    `json:"last_name"`
	RegistrationDate time.Time `json:"registration_date"`
	// Для отображения вместо ID
	CategoryName string `json:"category_name,omitempty"`
	LibraryName  string `json:"library_name,omitempty"`
}

type ReaderCategory struct {
	ID   int    `json:"id"`
	Name string `json:"name"`
}

type ReaderCategoryAttribute struct {
	ID         int    `json:"id"`
	CategoryID int    `json:"category_id"`
	Name       string `json:"name"`
}

type ReaderAttributeValue struct {
	ReaderID      int    `json:"reader_id"`
	CategoryID    int    `json:"category_id"`
	AttributeID   int    `json:"attribute_id"`
	Value         string `json:"value"`
	AttributeName string `json:"attribute_name,omitempty"`
}
