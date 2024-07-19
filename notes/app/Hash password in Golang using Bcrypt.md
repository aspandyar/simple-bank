ALG -> hash algorithm
COST -> number of iteration in power of 2 (2^10)
SALT -> 16 bytes => The salt is a random string added to the password before hashing to ensure that identical passwords produce different hashes. This makes precomputed hash attacks (like rainbow tables) ineffective. The salt in this example is 22 characters long and is encoded in base64.
HASH -> 24 bytes => The hash is the result of the bcrypt algorithm applied to the password and salt. In this example, it is 31 characters long and is also encoded in base64.


![[Pasted image 20240719232739.png]]

```go
func HashPassword(password string) (string, error) {  
    hashedPassword, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)  
    if err != nil {  
       return "", fmt.Errorf("failed to hash password: %w", err)  
    }  
    return string(hashedPassword), nil  
}  
  
func CheckPassword(password string, hashedPassword string) error {  
    return bcrypt.CompareHashAndPassword([]byte(hashedPassword), []byte(password))  
}
```

All already done by **bcrypt**

