# Define rjil::system::accounts::sudo
#
# == Purpose
# Call rjil::system::accounts::sudo::conf with appropriate params

define rjil::system::accounts::sudo (
  $active_users     = [],
  $users            = [],
  $commands_allowed = [],
) {

  ## Make an intersection of active users and sudo users,
  ##  so that sudo_users are always a subset of active_users

  $sudo_users = intersection($active_users,$users)

  ::rjil::system::accounts::sudo::conf { $sudo_users:
    commands_allowed => $commands_allowed,
  }
}
