alias TimeManager.Repo
alias TimeManager.Management.Clock

Repo.insert! %Clock{
    status: false,
    time: ~N[2021-10-26 17:33:43],
    user: 1
}

Repo.insert! %Clock{
    status: true,
    time: ~N[2021-10-26 17:33:43],
    user: 4
}
Repo.insert! %Clock{
    status: false,
    time: ~N[2021-10-26 17:33:43],
    user: 3
}
Repo.insert! %Clock{
    status: true,
    time: ~N[2021-10-26 17:33:43],
    user: 2
}
