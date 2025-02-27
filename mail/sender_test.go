package mail

import (
	"testing"

	"github.com/aspandyar/simple-bank/util"
	"github.com/stretchr/testify/require"
)

func TestSendEmailWithGmail(t *testing.T) {
	config, err := util.LoadConfig("..")
	require.NoError(t, err)

	sender := NewGmailSender(config.EmailSenderName, config.EmailSenderAddress, config.EmailSenderPassword)

	subject := "A test email"
	content := `
		<h1>Hello World!</h1>
		<p>This is a test email from the <b>Simple Bank</b> application.</p>
		
		<p>Sorry for the spam. Please ignore this email.</p>
	`
	to := []string{"stephen.novel@gmail.com"}
	attachFiles := []string{"../README.md"}

	err = sender.SendEmail(subject, content, to, nil, nil, attachFiles)
	require.NoError(t, err)
}
