package models

type Employee struct {
	ID            int    `json:"id"`
	LibraryID     int    `json:"library_id"`
	ReadingRoomID int    `json:"reading_room_id"`
	FirstName     string `json:"first_name"`
	LastName      string `json:"last_name"`
}
