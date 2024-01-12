package db

import (
	"context"
	"testing"
	"time"

	"github.com/stretchr/testify/require"

	"github.com/dedeco99/housekeeper/util"
)

func createRandomAccount(t *testing.T) Account {
	arg := CreateAccountParams{Name: util.RandomString(6), Email: util.RandomString(6) + "@gmail.com"}

	account, err := testQueries.CreateAccount(context.Background(), arg)

	require.NoError(t, err)
	require.NotEmpty(t, account)

	require.Equal(t, arg.Name, account.Name)
	require.Equal(t, arg.Email, account.Email)

	require.NotZero(t, account.ID)
	require.NotZero(t, account.Created)

	return account
}

func TestCreateAccount(t *testing.T) {
	createRandomAccount(t)
}

func TestGetAccounts(t *testing.T) {
	for i := 0; i < 10; i++ {
		createRandomAccount(t)
	}

	arg := GetAccountsParams{Limit: 5, Offset: 5}

	accounts, err := testQueries.GetAccounts(context.Background(), arg)

	require.NoError(t, err)
	require.Len(t, accounts, 5)

	for _, account := range accounts {
		require.NotEmpty(t, account)
	}
}

func TestGetAccount(t *testing.T) {
	account1 := createRandomAccount(t)

	account2, err := testQueries.GetAccount(context.Background(), account1.ID)

	require.NoError(t, err)
	require.NotEmpty(t, account2)

	require.Equal(t, account1.ID, account2.ID)
	require.Equal(t, account1.Name, account2.Name)
	require.Equal(t, account1.Email, account2.Email)

	require.WithinDuration(t, account1.Created, account2.Created, time.Second)
}

func TestUpdateAccount(t *testing.T) {
	account1 := createRandomAccount(t)

	arg := UpdateAccountParams{ID: account1.ID, Name: util.RandomString(6), Email: util.RandomString(6) + "@gmail.com"}

	account2, err := testQueries.UpdateAccount(context.Background(), arg)

	require.NoError(t, err)
	require.NotEmpty(t, account2)

	require.Equal(t, account1.ID, account2.ID)
	require.Equal(t, arg.Name, account2.Name)
	require.Equal(t, arg.Email, account2.Email)

	// TODO: test modify timestamp
}

func TestDeleteAccount(t *testing.T) {
	account1 := createRandomAccount(t)

	account2, err := testQueries.DeleteAccount(context.Background(), account1.ID)

	require.NoError(t, err)
	require.NotEmpty(t, account2)

	require.Equal(t, account2.Active, false)

	account3, err := testQueries.DeleteAccount(context.Background(), account1.ID)

	require.NoError(t, err)
	require.NotEmpty(t, account3)

	require.Equal(t, account3.Active, true)
}
