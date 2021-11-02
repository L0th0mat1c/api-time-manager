alias TimeManager.Repo
alias TimeManager.Management.WorkingTime

Repo.insert! %WorkingTime{
    start: ~N[2021-10-25 09:30:07],
    end: ~N[2021-10-25 17:33:43],
    user: 1
}

Repo.insert! %WorkingTime{
    start: ~N[2021-10-26 09:25:48],
    end: ~N[2021-10-26 17:48:22],
    user: 1
}

Repo.insert! %WorkingTime{
    start: ~N[2021-10-25 09:31:01],
    end: ~N[2021-10-25 17:52:10],
    user: 2
}
