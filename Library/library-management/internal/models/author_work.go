package models

type Author struct {
	ID        int    `json:"id"`
	FirstName string `json:"first_name"`
	LastName  string `json:"last_name"`
}

type Work struct {
	ID         int    `json:"id"`
	Title      string `json:"title"`
	CategoryID int    `json:"category_id"`
	Author     int    `json:"author"`
}
