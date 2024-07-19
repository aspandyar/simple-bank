package api

import (
	"errors"
	db "github.com/aspandyar/simple-bank/db/sqlc"
	"github.com/aspandyar/simple-bank/util"
	"github.com/gin-gonic/gin"
	"github.com/lib/pq"
	"net/http"
)

type createUserRequest struct {
	Username string `json:"username" binding:"required,alphanum"`
	Password string `json:"password" binding:"required,min=6"`
	FullName string `json:"full_name" binding:"required"`
	Email    string `json:"email" binding:"required,email"`
}

func (server *Server) createUser(ctx *gin.Context) {
	var req createUserRequest
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}

	hashedPassword, err := util.HashPassword(req.Password)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	arg := db.CreateUserParams{
		Username:       req.Username,
		HashedPassword: hashedPassword,
		FullName:       req.FullName,
		Email:          req.Email,
	}

	user, err := server.store.CreateUser(ctx, arg)
	if err != nil {
		var pqErr *pq.Error
		if errors.As(err, &pqErr) {
			switch pqErr.Code.Name() {
			case "unique_violation":
				ctx.JSON(http.StatusForbidden, errorResponse(err))
				return
			}
		}

		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	ctx.JSON(http.StatusOK, user)
}

//
//type getUserRequest struct {
//	ID int64 `uri:"id" binding:"required,min=1"`
//}
//
//func (server *Server) getAccount(ctx *gin.Context) {
//	var req getAccountRequest
//	if err := ctx.ShouldBindUri(&req); err != nil {
//		ctx.JSON(http.StatusBadRequest, errorResponse(err))
//		return
//	}
//
//	account, err := server.store.GetAccount(ctx, req.ID)
//	if err != nil {
//		if errors.Is(err, sql.ErrNoRows) {
//			ctx.JSON(http.StatusNotFound, errorResponse(err))
//			return
//		}
//		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
//		return
//	}
//
//	ctx.JSON(http.StatusOK, account)
//}
