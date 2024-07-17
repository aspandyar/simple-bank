
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

```
