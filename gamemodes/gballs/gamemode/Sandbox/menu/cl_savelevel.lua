function GB:SaveLevel()
    self.savedProps = self.propList
    hook.Run("SendNotification", 1, gb.blackNotch2, " Level Saved", Color(255, 255, 255), self.messageType.MESSAGE)
end