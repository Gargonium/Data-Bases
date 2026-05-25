package service

import (
	"context"
	"library-management/internal/models"
	"library-management/internal/repository"
)

type ReaderService struct {
	readerRepo *repository.ReaderRepo
}

func NewReaderService(readerRepo *repository.ReaderRepo) *ReaderService {
	return &ReaderService{readerRepo: readerRepo}
}

func (s *ReaderService) Create(ctx context.Context, reader *models.Reader) (int, error) {
	// Здесь можно добавить бизнес-логику (например, проверка уникальности)
	return s.readerRepo.Create(ctx, reader)
}

func (s *ReaderService) GetByID(ctx context.Context, id int) (*models.Reader, error) {
	return s.readerRepo.GetByID(ctx, id)
}

func (s *ReaderService) Update(ctx context.Context, reader *models.Reader) error {
	return s.readerRepo.Update(ctx, reader)
}

func (s *ReaderService) Delete(ctx context.Context, id int) error {
	return s.readerRepo.Delete(ctx, id)
}

func (s *ReaderService) List(ctx context.Context, limit, offset int) ([]models.Reader, error) {
	return s.readerRepo.List(ctx, limit, offset)
}

// GetAllCategories возвращает все категории читателей
func (s *ReaderService) GetAllCategories(ctx context.Context) ([]models.ReaderCategory, error) {
	return s.readerRepo.GetAllCategories(ctx)
}

// GetAllLibraries возвращает все библиотеки
func (s *ReaderService) GetAllLibraries(ctx context.Context) ([]models.Library, error) {
	return s.readerRepo.GetAllLibraries(ctx)
}
