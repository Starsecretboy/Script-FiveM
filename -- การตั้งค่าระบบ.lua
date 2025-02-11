-- การตั้งค่าระบบ
local airdropItems = {"weapon_assaultrifle", "weapon_pistol", "money", "armor"}  -- รายการไอเทมที่มีใน Airdrop
local airdropLocations = {
    {x = 123.4, y = 456.7, z = 78.9},  -- ตัวอย่างตำแหน่งที่ 1
    {x = -210.2, y = 312.6, z = 95.2}, -- ตัวอย่างตำแหน่งที่ 2
    {x = 600.5, y = -1000.7, z = 35.3} -- ตัวอย่างตำแหน่งที่ 3
}

-- ฟังก์ชันการประกาศ Airdrop
local function announceAirdrop(location)
    TriggerClientEvent('chatMessage', -1, "^3[AIRDROP]", {255, 0, 0}, "Airdrop ได้ถูกทิ้งที่พิกัด: (" .. location.x .. ", " .. location.y .. ")! มาสู้กัน!")
    TriggerClientEvent('playAirdropSoundGlobal', -1)  -- ส่งเสียงแจ้งเตือนให้ทุกคน
end

-- ฟังก์ชันการสร้าง Airdrop
local function spawnAirdrop(location)
    -- สุ่มเลือกไอเทมจากรายการที่ตั้งไว้
    local itemIndex = math.random(1, #airdropItems)
    local selectedItem = airdropItems[itemIndex]
    
    -- แสดงข้อความสำหรับการสร้าง Airdrop (สามารถแทนที่ด้วยการสร้างวัตถุจริง)
    print("กำลังสร้าง Airdrop พร้อมไอเทม: " .. selectedItem .. " ที่พิกัด (" .. location.x .. ", " .. location.y .. ", " .. location.z .. ")")
    -- คุณสามารถแทนที่ด้วยการสร้างวัตถุหรือการให้ไอเทมจริง ๆ ในเกม
end

-- ฟังก์ชันหลักสำหรับการเริ่มต้น Airdrop
local function startAirdrop()
    local locationIndex = math.random(1, #airdropLocations)
    local selectedLocation = airdropLocations[locationIndex]
    
    announceAirdrop(selectedLocation)
    Citizen.Wait(10000)  -- รอ 10 วินาทีก่อนที่จะสร้าง Airdrop (เพิ่มความตื่นเต้น)
    spawnAirdrop(selectedLocation)
end

-- เรียก Airdrop ทุกครั้งที่มีผู้เล่นเข้ามาในเซิร์ฟเวอร์
AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
    -- เมื่อผู้เล่นเชื่อมต่อ เซิร์ฟเวอร์จะทำการเรียก Airdrop
    startAirdrop()
end)

-- ฟังก์ชันสำหรับรัน Airdrop อัตโนมัติทุกๆ 10-20 นาที
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(math.random(600000, 1200000))  -- รัน Airdrop ทุกๆ 10-20 นาที (600,000ms - 1,200,000ms)
        startAirdrop()  -- เรียกใช้ Airdrop
    end
end)

-- คำสั่งสำหรับเริ่ม Airdrop แบบแมนนวล (ใช้สำหรับทดสอบ)
RegisterCommand("triggerairdrop", function(source, args, rawCommand)
    -- ใช้คำสั่งเพื่อเรียก Airdrop จากคำสั่งนี้ในเกม
    startAirdrop()
end, false)

-- สคริปต์ฝั่งลูกค้า (เพิ่มในไฟล์ลูกค้า)
RegisterNetEvent('playAirdropSoundGlobal')
AddEventHandler('playAirdropSoundGlobal', function()
    PlaySound(-1, "Air_Defences_Activated", "DLC_AW_Frontend_Sounds", 0, 0, 1)
end)
