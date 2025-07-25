ESX.RegisterServerCallback('dk_truckerjob:isPlayerBusy', function(source, cb)
    cb(false) 
end)

RegisterServerEvent('dk_truckerjob:startJob')
AddEventHandler('dk_truckerjob:startJob', function(deliveryType)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getJob().name == Config.RequiredJob then
        local pickupPoint, dropoffPoint

        if deliveryType == 'short' then
            pickupPoint = Config.ShortHaul.PickupLocations[math.random(1, #Config.ShortHaul.PickupLocations)]
            dropoffPoint = Config.ShortHaul.DropoffLocations[math.random(1, #Config.ShortHaul.DropoffLocations)]
        elseif deliveryType == 'long' then
            pickupPoint = Config.LongHaul.PickupLocations[math.random(1, #Config.LongHaul.PickupLocations)]
            dropoffPoint = Config.LongHaul.DropoffLocations[math.random(1, #Config.LongHaul.DropoffLocations)]
        else
            print(('[dk_truckerjob] Error: Invalid delivery type "%s" received.'):format(deliveryType))
            return
        end

        TriggerClientEvent('dk_truckerjob:startDelivery', source, pickupPoint, dropoffPoint, deliveryType)
    else
        xPlayer.showNotification(Locale['not_trucker'])
    end
end)

RegisterServerEvent('dk_truckerjob:completeDelivery')
AddEventHandler('dk_truckerjob:completeDelivery', function(deliveryType)
    local xPlayer = ESX.GetPlayerFromId(source)
    local payment = 0

    if deliveryType == 'short' then
        payment = math.random(Config.ShortHaul.Payment.Min, Config.ShortHaul.Payment.Max)
    elseif deliveryType == 'long' then
        payment = math.random(Config.LongHaul.Payment.Min, Config.LongHaul.Payment.Max)
    end
    
    if payment > 0 then
        xPlayer.addMoney(payment)
        xPlayer.showNotification(string.format(Locale['payment_received'], payment))
    end
end)

-- NEW: Event to handle job failure and apply a fee
RegisterServerEvent('dk_truckerjob:jobFailed')
AddEventHandler('dk_truckerjob:jobFailed', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if xPlayer then
        xPlayer.removeAccountMoney('bank', Config.PenaltyFee)
        xPlayer.showNotification(string.format(Locale['fee_charged'], Config.PenaltyFee))
    end
end)
