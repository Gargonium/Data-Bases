package service

import (
	"context"
	"errors"
	"golang.org/x/crypto/bcrypt"
	"library-management/internal/auth"
	"library-management/internal/models"
	"library-management/internal/repository"
	"time"
)

type AuthService struct {
	userRepo     *repository.UserRepo
	readerRepo   *repository.ReaderRepo
	employeeRepo *repository.EmployeeRepo
}

func NewAuthService(userRepo *repository.UserRepo, readerRepo *repository.ReaderRepo, employeeRepo *repository.EmployeeRepo) *AuthService {
	return &AuthService{
		userRepo:     userRepo,
		readerRepo:   readerRepo,
		employeeRepo: employeeRepo,
	}
}

func (s *AuthService) Register(ctx context.Context, req models.RegisterRequest) (int, error) {
	// Проверка существования логина
	existing, _ := s.userRepo.GetByLogin(ctx, req.Login)
	if existing != nil {
		return 0, errors.New("login already exists")
	}

	// Автоматический подбор reader_id или employee_id в зависимости от роли
	var readerID, employeeID *int
	switch req.Role {
	case "reader":
		id, err := s.readerRepo.GetFreeReaderID(ctx)
		if err != nil {
			// если нет свободного, создаём нового читателя
			newReader := &models.Reader{
				FirstName:        "Новый",
				LastName:         "Читатель",
				CategoryID:       1, // по умолчанию
				LibraryID:        1,
				RegistrationDate: time.Now(),
			}
			newID, err := s.readerRepo.Create(ctx, newReader)
			if err != nil {
				return 0, errors.New("cannot create new reader")
			}
			readerID = &newID
		} else {
			readerID = &id
		}
	case "librarian":
		id, err := s.employeeRepo.GetFreeEmployeeID(ctx)
		if err != nil {
			return 0, errors.New("no available employee ID for registration")
		}
		employeeID = &id
	case "admin":
		// ничего не делаем
	default:
		return 0, errors.New("invalid role")
	}

	//Хэширование пароля
	hash, err := bcrypt.GenerateFromPassword([]byte(req.Password), bcrypt.DefaultCost)
	if err != nil {
		return 0, err
	}

	user := &models.User{
		Login:        req.Login,
		PasswordHash: string(hash),
		Role:         req.Role,
		ReaderID:     readerID,
		EmployeeID:   employeeID,
	}
	return s.userRepo.Create(ctx, user)
}
func (s *AuthService) Login(ctx context.Context, login, password string) (*models.LoginResponse, error) {
	user, err := s.userRepo.GetByLogin(ctx, login)
	if err != nil || user == nil {
		return nil, errors.New("invalid credentials")
	}
	if err := bcrypt.CompareHashAndPassword([]byte(user.PasswordHash), []byte(password)); err != nil {
		return nil, errors.New("invalid credentials")
	}
	token, err := auth.GenerateToken(user.ID, user.Role)
	if err != nil {
		return nil, err
	}
	resp := &models.LoginResponse{
		Token: token,
		Role:  user.Role,
	}
	if user.ReaderID != nil {
		reader, err := s.readerRepo.GetByID(ctx, *user.ReaderID)
		if err == nil && reader != nil {
			resp.ReaderID = user.ReaderID
			resp.FirstName = reader.FirstName
			resp.LastName = reader.LastName
			// можно также добавить название библиотеки
			// для этого нужен запрос к libraries по reader.LibraryID
			// предположим, что в reader.LibraryName уже есть (если GetByID делает JOIN)
		}
	} else if user.EmployeeID != nil {
		emp, err := s.employeeRepo.GetByID(ctx, *user.EmployeeID)
		if err == nil && emp != nil {
			resp.EmployeeID = user.EmployeeID
			resp.FirstName = emp.FirstName
			resp.LastName = emp.LastName
			// название библиотеки можно получить аналогично
		}
	}
	return resp, nil
}
