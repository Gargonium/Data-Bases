package models

import "time"

type Loan struct {
	ID                  int        `json:"id"`
	ReaderID            int        `json:"reader_id"`
	CopyInventoryNumber int        `json:"copy_inventory_number"`
	DateOfIssue         time.Time  `json:"date_of_issue"`
	ReturnDate          *time.Time `json:"return_date,omitempty"`
	ExpireDate          time.Time  `json:"expire_date"`
	IssuedEmployeeID    int        `json:"issued_employee_id"`
}
