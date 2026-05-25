package models

import "time"

type Publication struct {
	ID          int       `json:"id"`
	Title       string    `json:"title"`
	PublishDate time.Time `json:"publish_date"`
	Publisher   string    `json:"publisher"`
}

type PublicationCopy struct {
	InventoryNumber    int       `json:"inventory_number"`
	PublicationID      int       `json:"publication_id"`
	ShelfID            int       `json:"shelf_id"`
	ReceiptDate        time.Time `json:"receipt_date"`
	ReceivedEmployeeID int       `json:"received_employee_id"`
}

type PublicationRule struct {
	PublicationID   int  `json:"publication_id"`
	ReadingRoomOnly bool `json:"reading_room_only"`
	LoanPeriodDays  *int `json:"loan_period_days,omitempty"`
}
