while wait(0.1) do
    local player = game.Players.LocalPlayer
    if player and player.Character then
        game:GetService("ReplicatedStorage").Remotes.Rebirth:FireServer()
        player.Character:BreakJoints()
    end
end
