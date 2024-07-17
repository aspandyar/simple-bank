
## Workflow:

- Is an automated procedure
- Made up of 1+ jobs
- Triggered by events, scheduler or manually
- Add .yml file to repository

![[Pasted image 20240717161205.png]]

### Runnner

- Is a server to run the jobs
- Run 1 job at a time
- GitHub hosted or self hosted
- Report process, logs & result to github

![[Pasted image 20240717161223.png]]

### Job

- Is a set of steps execute on the same runner
- Normal jobs run in parallel
- Dependent jobs run serially 

![[Pasted image 20240717161233.png]]


### Step

- Is an individual task
- Run serially within a job
- Contain 1+ actions

### Action

- Is a standalone command
- Run serially withing a step
- Can be reused

![[Pasted image 20240717161414.png]]


### Overview:

![[Pasted image 20240717161530.png]]


### Example of go.yml file:

```yml
name: ci-test  
  
on:  
  push:  
    branches: [ "main" ]  
  pull_request:  
    branches: [ "main" ]  
  
jobs:  
  
  test:  
    name: Test  
    runs-on: ubuntu-latest  
  
    services:  
      postgres:  
        image: postgres:latest  
        env:  
          POSTGRES_USER: root  
          POSTGRES_PASSWORD: qwerty123  
          POSTGRES_DB: simple_bank  
        options: >-  
          --health-cmd pg_isready  
          --health-interval 10s  
          --health-timeout 5s  
          --health-retries 5  
        ports:  
          - 5432:5432  
  
    steps:  
    - uses: actions/checkout@v4  
  
    - name: Set up Go  
      uses: actions/setup-go@v4  
      with:  
        go-version: '1.21'  
  
    - name: Check out code into the Go module directory  
      uses: actions/checkout@v2  
      with:  
        submodules: recursive  
  
    - name: Install golang-migrate  
      run: |  
        curl -L https://github.com/golang-migrate/migrate/releases/download/v4.17.1/migrate.linux-amd64.tar.gz | tar xvz  
        sudo mv migrate /usr/bin/  
        which migrate  
  
    - name: Run migrations  
      run: make migrateup  
  
    - name: Test  
      run: make test
```
