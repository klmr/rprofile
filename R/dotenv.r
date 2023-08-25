load_project_dotenv = function () {
  if (file.exists('.env')) {
    readRenviron('.env')
  }
}
