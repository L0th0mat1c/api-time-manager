alias TimeManager.Repo
alias TimeManager.Account.User

Repo.insert! %User{
    username: "John  Rambo",
    email: "loic1.thomas@epitech.eu"
}

Repo.insert! %User{
    username: "Dimitri Gillet",
    email: "dimitri.gillet@epitech.eu"
}

Repo.insert! %User{
    username: "Lilian Garrido",
    email: "lilian.garrido@epitech.eu"
}

Repo.insert! %User{
    username: "Tom LEAL",
    email: "tom.leal@epitech.eu"
}
