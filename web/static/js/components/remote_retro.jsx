import React, { Component, PropTypes } from "react"
import { connect } from "react-redux"
import { Presence } from "phoenix"

import { addUser } from "../actions/user"
import * as AppPropTypes from "../prop_types"
import Room from "./room"

const isFacilitator = currentPresence => {
  if (currentPresence) {
    return currentPresence.user.is_facilitator
  }

  return false
}

class RemoteRetro extends Component {
  constructor(props) {
    super(props)
    this.state = {
      presences: {},
    }
  }

  componentWillMount() {
    this.props.retroChannel.on("presence_state", presences => addUser)
    this.props.retroChannel.join()
      .receive("error", error => console.error(error))
  }

  render() {
    const { userToken, retroChannel } = this.props
    const { presences } = this.state

    const users = Presence.list(presences, (_username, presence) => (presence.user))
    const currentPresence = presences[userToken]

    return (
      <Room
        currentPresence={currentPresence}
        users={users}
        isFacilitator={isFacilitator(currentPresence)}
        retroChannel={retroChannel}
      />
    )
  }
}

RemoteRetro.propTypes = {
  retroChannel: AppPropTypes.retroChannel.isRequired,
  userToken: PropTypes.string.isRequired,
}

const mapStateToProps = state => ({
  user: state.user,
})

const mapDispatchToProps = dispatch => ({
  addUser: dispatch(addUser())
})

export default connect(
  mapStateToProps,
  mapDispatchToProps,
)(RemoteRetro)
