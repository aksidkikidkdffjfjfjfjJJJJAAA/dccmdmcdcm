-- ＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿@
-- LUAスクリプト テンプレ(メニュー式) by TAPI
-- 
-- {name = "オフセット型マクロ", offset = 0x29232C4, hex = "EB FE FF 54"},
--
-- バグなどがあるかもしれないので修正できたらしときます
-- 
-- 質問などがあればDiscordにお願いします
-- DiscordURL⬇
-- https://discord.gg/6FQPgbBWGR
-- 
-- 範囲はXa
-- offsetの取得方法は自分で調べて( 'ω')b
--
--  _______                                    
-- |__   __|                   (_)                
--   | |      __ _     _ __    _ 
--   | |    / _`  |   | '_ \ \  | |
--   | |   | (_|  |   |  |_)  |  | | 
--   |_|    \__,_ \  |  __ /   |_|
--                 | |                      
--                |_|
-- ＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿@

local libName = "libcocos2dcpp.so"
local password = "test"
local base = 0
local backupFile = "/sdcard/TAPIModBuckUpTumuTumu.lua"

function auth()
    local input = gg.prompt({"パスワードを入力してください"}, nil, {"text"})
    if input == nil or input[1] ~= password then
        gg.alert("パスワードが違います\nスクリプトを終了します。")
        os.exit()
    end
end

function getLibBase(lib)
    for _, v in ipairs(gg.getRangesList(lib)) do
        if v.state == "Xa" and v.type:sub(1,1) == "r" then
            return v.start
        end
    end
    gg.alert("⚠️ ライブラリが見つかりません\nエラーが発生する恐れがあります\n対象ライブラリ\n" .. lib)
    --os.exit()
end

function hexToBytes(hex)
    local bytes = {}
    for byte in hex:gmatch("%S+") do
        table.insert(bytes, tonumber(byte, 16))
    end
    return bytes
end

function readOriginal(offset, length)
    local addr = base + offset
    local values = {}
    for i = 0, length - 1 do
        table.insert(values, {address = addr + i, flags = gg.TYPE_BYTE})
    end
    return gg.getValues(values)
end

function patch(offset_or_qtext, hex, enable, backup, override_addr)
    local addr
    local bytes = hexToBytes(hex)

    if override_addr then
        addr = override_addr
    elseif type(offset_or_qtext) == "number" then
        addr = base + offset_or_qtext
    elseif type(offset_or_qtext) == "string" then
        gg.clearResults()
        gg.searchNumber(offset_or_qtext, gg.TYPE_QWORD)
        local results = gg.getResults(1)
        if #results == 0 then
            gg.alert("🈲 無効なアドレス\n数値パターンが変更されました。\n製作者が更新するまでお待ちください")
            return nil
        end
        addr = results[1].address
    else
        gg.alert("🈲 無効なアドレス\n数値パターンが変更されました。\n製作者が更新するまでお待ちください")
        return nil
    end

    if enable then
        local values = {}
        for i = 0, #bytes - 1 do
            table.insert(values, {
                address = addr + i,
                flags = gg.TYPE_BYTE,
                value = bytes[i + 1]
            })
        end
        local original = gg.getValues(values)
        gg.setValues(values)
        return {address = addr}
    else
        local values = {}
        for i = 0, #bytes - 1 do
            table.insert(values, {
                address = override_addr + i,
                flags = gg.TYPE_BYTE,
                value = bytes[i + 1]
            })
        end
        gg.setValues(values)
    end
end

local gamespeedFeatures = {

{name = "倍速レベル〖3〗",
   qwordtext = "2,172,706,449,541,564,448;5,955,817,028,016,603,393;2,171,025,292,849,008,648;2,172,706,449,541,629,952:13",
   hex = "20 08 20 1E",
   off_hex = "00 28 28 1E",
   assnbly = "~A8 FADD S0, S0, S8"
},

{name = "倍速レベル〖5〗",
   qwordtext = "2,172,706,449,541,564,448;5,955,817,028,016,603,393;2,171,025,292,849,008,648;2,172,706,449,541,629,952:13",
   hex = "20 08 20 1E",
   off_hex = "00 28 28 1E",
   assnbly = "~A8 FADD S0, S0, S8"
},

{name = "倍速レベル〖10〗",
   qwordtext = "2,172,706,449,541,564,448;5,955,817,028,016,603,393;2,171,025,292,849,008,648;2,172,706,449,541,629,952:13",
   hex = "00 28 28 1E",
   off_hex = "00 28 28 1E",
   assnbly = "~A8 FADD S0, S0, S8"},

}

local coinFeatures = {

{name = "倍速レベル〖1〗",
   qwordtext = "-3,816,518,074,842,933,248;-7,052,072,959,295,815,416;2,171,060,478,487,429,377;3,386,957,613,234,202,624:13",
   hex = "00 28 28 1E",
   off_hex = "00 18 21 1E",
   assnbly = "~A8 FDIV S0, S0, S1"
},

{name = "倍速レベル〖2〗",
   qwordtext = "-3,816,518,074,842,933,248;-7,052,072,959,295,815,416;2,171,060,478,487,429,377;3,386,957,613,234,202,624:13",
   hex = "00 10 28 1E",
   off_hex = "00 18 21 1E",
   assnbly = "~A8 FDIV S0, S0, S1"
},

{name = "倍速レベル〖3〗",
   qwordtext = "-3,816,518,074,842,933,248;-7,052,072,959,295,815,416;2,171,060,478,487,429,377;3,386,957,613,234,202,624:13",
   hex = "00 90 28 1E",
   off_hex = "00 18 21 1E",
   assnbly = "~A8 FDIV S0, S0, S1"
},

{name = "倍速レベル〖4〗",
   qwordtext = "-3,816,518,074,842,933,248;-7,052,072,959,295,815,416;2,171,060,478,487,429,377;3,386,957,613,234,202,624:13",
   hex = "00 50 29 1E",
   off_hex = "00 18 21 1E",
   assnbly = "~A8 FDIV S0, S0, S1"
},

{name = "倍速レベル〖5〗",
   qwordtext = "-3,816,518,074,842,933,248;-7,052,072,959,295,815,416;2,171,060,478,487,429,377;3,386,957,613,234,202,624:13",
   hex = "00 90 29 1E",
   off_hex = "00 18 21 1E",
   assnbly = "~A8 FDIV S0, S0, S1"
},

{name = "倍速レベル〖6〗",
   qwordtext = "-3,816,518,074,842,933,248;-7,052,072,959,295,815,416;2,171,060,478,487,429,377;3,386,957,613,234,202,624:13",
   hex = "00 70 2A 1E",
   off_hex = "00 18 21 1E",
   assnbly = "~A8 FDIV S0, S0, S1"
},

{name = "倍速レベル〖7〗",
   qwordtext = "-3,816,518,074,842,933,248;-7,052,072,959,295,815,416;2,171,060,478,487,429,377;3,386,957,613,234,202,624:13",
   hex = "00 10 2E 1E",
   off_hex = "00 18 21 1E",
   assnbly = "~A8 FDIV S0, S0, S1"},

}

local speedFeatures = {

{name = "コイン増殖〖50万〗",
   qwordtext = "-990,790,495,682,624,524;-6,196,948,740,985,585,333;-7,310,466,666,347,887,629;8,265,896,796,921,528,652:13",
   hex = "F4 13 12 32",
   off_hex = "F4 03 01 2A",
   assnbly = "~A8 MOV W20, W1"
},

{name = "コイン増殖〖1600万〗",
   qwordtext = "-990,790,495,682,624,524;-6,196,948,740,985,585,333;-7,310,466,666,347,887,629;8,265,896,796,921,528,652:13",
   hex = "F4 13 2D 32",
   off_hex = "F4 03 01 2A",
   assnbly = "~A8 MOV W20, W1"
},

{name = "コイン増殖〖3000万〗",
   qwordtext = "-990,790,495,682,624,524;-6,196,948,740,985,585,333;-7,310,466,666,347,887,629;8,265,896,796,921,528,652:13",
   hex = "F4 03 27 32",
   off_hex = "F4 03 01 2A",
   assnbly = "~A8 MOV W20, W1"
},

{name = "コイン増殖〖5000万〗",
   qwordtext = "-990,790,495,682,624,524;-6,196,948,740,985,585,333;-7,310,466,666,347,887,629;8,265,896,796,921,528,652:13",
   hex = "F4 07 28 32",
   off_hex = "F4 03 01 2A",
   assnbly = "~A8 MOV W20, W1"
},

{name = "コイン増殖〖1.3億〗",
   qwordtext = "-990,790,495,682,624,524;-6,196,948,740,985,585,333;-7,310,466,666,347,887,629;8,265,896,796,921,528,652:13",
   hex = "F4 13 2A 32",
   off_hex = "F4 03 01 2A",
   assnbly = "~A8 MOV W20, W1"},

}

local mainFeatures = {

{name = "即終了(PC不可)",
   qwordtext = "6,124,894,029,145,513,984;-486,372,914,195,595,605;-5,476,375,729,656,557,975;-6,249,960,093,140,385,463:13",
   hex = "00 10 24 1E",
   off_hex = "00 20 21 1E",
   assnbly = "~A8 FCMP S0, S1"
},

{name = "ツム消し即終了",
   qwordtext = "-7,997,597,852,454,877,407;-7,769,868,961,591,405,792;3,891,118,326,871,220,568;-7,997,527,484,214,016,128:13",
   hex = "20 07 00 54",
   off_hex = "21 07 00 54",
   assnbly = "~A8 B.NE [PC,#0xE4]"
},

{name = "スタート演出無効",
   qwordtext = "5,945,489,315,297,431,553;-8,428,483,999,705,161,976;2,171,051,682,073,936,501;6,052,839,570,433,712,128:13",
   hex = "01 10 28 1E",
   off_hex = "01 10 2F 1E",
   assnbly = "~A8 FMOV S1, #0x3FC00000"
},

{name = "リザルト演出無効",
   qwordtext = "-5,764,473,832,882,502,668;-6,191,600,799,143,921,257;5,944,751,652,716,348,384;5,944,751,750,031,343,649:13",
   hex = "34 00 80 52",
   off_hex = "F4 03 01 2A",
   assnbly = "~A8 MOV W20, W1"
},

{name = "コイン演出無効",
   qwordtext = "0",
   hex = "80 00 00 54",
   off_hex = "00 20 21 1E",
   assnbly = "~A8 MOV W20, W1"
},

{name = "ガチャスキップ",
   qwordtext = "-486,370,029,516,881,048;-3,008,684,922,366,848,760;-5,764,476,595,951,697,664;-5,116,080,515,085,994,221:13",
   hex = "C0 03 5F D6",
   off_hex = "68 03 40 F9",
   assnbly = "~A8 LDR X8, [X27]"
},

{name = "ツムレベル",
   qwordtext = "-7,769,845,981,369,072,351;-5,097,720,286,276,749,761;8,142,518,158,142,554,728;6,052,839,309,831,047,455:13",
   hex = "01 20 A0 52",
   off_hex = "21 05 00 11",
   assnbly = "~A8 ADD W1, W9, #0x1"
},
   
{name = "プレイヤーレベルx1000",
   qwordtext = "-990,790,495,682,624,524;-6,196,948,740,985,585,333;-7,310,466,666,347,887,629;8,262,632,346,898,661,708:13",
   hex = "F4 17 3C 32",
   off_hex = "F4 03 01 2A",
   assnbly = "~A8 MOV W20, W1"
},
   
{name = "プレイヤーレベルx5000",
   qwordtext = "-990,790,495,682,624,524;-6,196,948,740,985,585,333;-7,310,466,666,347,887,629;8,262,632,346,898,661,708:13",
   hex = "F4 07 35 32",
   off_hex = "F4 03 01 2A",
   assnbly = "~A8 MOV W20, W1"
},
   
{name = "プレイヤーレベルx1000",
   qwordtext = "-990,790,495,682,624,524;-6,196,948,740,985,585,333;-7,310,466,666,347,887,629;8,262,632,346,898,661,708:13",
   hex = "F4 07 27 32",
   off_hex = "F4 03 01 2A",
   assnbly = "~A8 MOV W20, W1"},

}

local puzzleFeatures = {

{name = "ツム繋げ時スコア大幅UP",
   qwordtext = "2,177,771,895,316,285,440;-6,249,782,472,985,739,264;-6,250,055,140,946,718,732;-6,250,327,811,240,536,074:13",
   hex = "00 08 20 1E",
   off_hex = "00 08 28 1E",
   assnbly = "~A8 FMUL S0, S0, S8"
},

{name = "スコアカンスト",
   qwordtext = "-7,769,893,449,446,981,375;-5,092,099,578,540,602,605;1,346,576,334,642,821,737;-483,395,442,115,084,278:13",
   hex = "81 7D A1 72",
   off_hex = "01 01 14 0B",
   assnbly = "~A8 ADD W1, W8, W20"
},

{name = "ツムサイズ変更",
   qwordtext = "0",
   hex = "80 00 00 54",
   off_hex = "00 20 21 1E",
   assnbly = "~A8 MOV W20, W1"
},

{name = "ツム1色",
   qwordtext = "0",
   hex = "80 00 00 54",
   off_hex = "00 20 21 1E",
   assnbly = "~A8 MOV W20, W1"
},

{name = "無限F",
   qwordtext = "0",
   hex = "80 00 00 54",
   off_hex = "00 20 21 1E",
   assnbly = "~A8 MOV W20, W1"
},

{name = "即F",
   qwordtext = "0",
   hex = "80 00 00 54",
   off_hex = "00 20 21 1E",
   assnbly = "~A8 MOV W20, W1"
},

{name = "スキル無限発動",
   qwordtext = "0",
   hex = "80 00 00 54",
   off_hex = "00 20 21 1E",
   assnbly = "~A8 MOV W20, W1"
},

{name = "時間停止",
   qwordtext = "-486,341,669,228,244,991;-4,808,957,229,405,295,916;8,214,566,956,154,693,344;-486,385,974,704,602,849:13",
   hex = "09 20 31 18",
   off_hex = "01 10 2E 1E",
   assnbly = "~A8 FMOV S1, #0x3F800000"
},

{name = "繋がりやすさUP",
   qwordtext = "2,234,067,062,456,649,728;2,171,623,701,185,888,296;3,900,120,473,264,138,304;-5,097,702,695,668,546,840:13",
   hex = "00 08 20 1E",
   off_hex = "00 08 21 1E",
   assnbly = "~A8 FMUL S0, S0, S0"
},

{name = "確定全繋がり",
   qwordtext = "-6,250,578,480,750,589,952;7,836,865,788,052,077,565;-2,999,674,701,812,194,327;-2,999,674,700,040,305,728:13",
   hex = "00 08 20 1E",
   off_hex = "00 08 29 1E",
   assnbly = "~A8 FMUL S0, S0, S9"
},

{name = "オートチェーン",
   qwordtext = "4,127,030,130,759,768,072;3,028,953,359,215,634,441;8,142,509,359,646,703,880;1,918,278,219,019,059,487:13",
   hex = "01 6A 98 52",
   off_hex = "08 18 45 B9",
   assnbly = "~A8 LDR W8, [X0,#0x518]"
},

{name = "コンボカンスト",
   qwordtext = "0",
   hex = "80 00 00 54",
   off_hex = "00 20 21 1E",
   assnbly = "~A8 MOV W20, W1"
},

{name = "ボナ玉生成",
   qwordtext = "0",
   hex = "80 00 00 54",
   off_hex = "00 20 21 1E",
   assnbly = "~A8 MOV W20, W1"
},

{name = "イベント情報ダイアログ無効",
   qwordtext = "-5,098,074,738,119,409,472;8,142,527,091,674,447,881;6,124,894,812,219,904,319;3,891,109,121,696,464,737:13",
   hex = "C1 00 00 54",
   off_hex = "C0 00 00 54",
   assnbly = "~A8 B.EQ [PC,#0x18]"},

}

local states, backups = {}, {}

function toggleFeature(list, index)
    local feat = list[index]
    local patchTarget = feat.offset or feat.qwordtext
    if not states[feat.name] then
        local patched = patch(patchTarget, feat.hex, true)
        if patched then
            backups[feat.name] = patched
            states[feat.name] = true
            gg.toast(feat.name .. "〘ON〙")
        end
    else
        if backups[feat.name] and feat.off_hex then
            patch(nil, feat.off_hex, false, nil, backups[feat.name].address)
            states[feat.name] = false
            gg.toast(feat.name .. "〘OFF〙")
        else
            gg.alert("復元用のHEXまたはアドレスがありません")
        end
    end
end

function showFeatureMenu(list, title)
    while true do
        local menu = {}
        local choices = {}

        for i, feat in ipairs(list) do
            menu[i] = feat.name
            choices[i] = states[feat.name] or false
        end

        table.insert(menu, "戻る")
        table.insert(choices, false)

        local sel = gg.multiChoice(menu, choices, title)
        if sel == nil then return end

        for i = 1, #list do
            local desired = sel[i] or false
            local current = states[menu[i]] or false
            if desired ~= current then
                toggleFeature(list, i)
            end
        end

        if sel[#menu] then return end
    end
end

function saveBackup()
    local file = io.open(backupFile, "w")
    if not file then return end
    for name, v in pairs(states) do
        if v then file:write(name .. "\n") end
    end
    file:close()
    gg.toast("状態をバックアップしました")
end

function loadBackup()
    local file = io.open(backupFile, "r")
    if not file then
        gg.alert("バックアップが見つかりません")
        return
    end
    for line in file:lines() do
        local name = line:match("^(.-)%s*$")
        for _, list in ipairs({coinFeatures, speedFeatures, mainFeatures, puzzleFeatures}) do
            for i, feat in ipairs(list) do
                if feat.name == name then
                    local patched = patch(feat.offset or feat.qwordtext, feat.hex, true)
                    if patched then
                        backups[name] = patched
                        states[name] = true
                        gg.toast(name .. " 〘復元ON〙")
                    end
                end
            end
        end
    end
    file:close()
end

function restoreAll()
    for name, enabled in pairs(states) do
        if enabled and backups[name] then
            for _, list in ipairs({coinFeatures, speedFeatures, mainFeatures, puzzleFeatures}) do
                for _, feat in ipairs(list) do
                    if feat.name == name and feat.off_hex then
                        patch(nil, feat.off_hex, false, nil, backups[name].address)
                        states[name] = false
                        gg.toast(name .. "〖OFF〗")
                    end
                end
            end
        end
    end
end

function showSettingMenu()
    local opts = {
        "機能保存",
        "機能バックアップ復元",
        "戻る"
    }
    local sel = gg.choice(opts, nil, "〖Setting Menu〗")
    if sel == 1 then saveBackup()
    elseif sel == 2 then loadBackup()
    end
end

function mainMenu()
    while true do
        local opts = {
            "〖GAME Speed Menu〗",
            "〖TIME Speed Menu〗",
            "〖Coin Menu〗",
            "〖Main Menu〗",
            "〖Puzzle Menu〗",
            "〖Setting Menu〗",
            "〖_EXIT_〗"
        }
        local sel = gg.choice(opts, nil, "ツムツムスクリプト by TAPI\n使用期限は無限(数値パターンが変われば使えなくなります)")
        if sel == nil then return end
        if sel == 1 then showFeatureMenu(gamespeedFeatures, "〖GAME Speed Menu〗")
        elseif sel == 2 then showFeatureMenu(coinFeatures, "〖TIME Speed Menu〗")
        elseif sel == 3 then showFeatureMenu(speedFeatures, "〖Coin Menu〗")
        elseif sel == 4 then showFeatureMenu(mainFeatures, "〖Main Menu〗")
        elseif sel == 5 then showFeatureMenu(puzzleFeatures, "〖Puzzle Menu〗")
        elseif sel == 6 then showSettingMenu()
        elseif sel == 7 then
            restoreAll()
            os.remove(backupFile)
            gg.alert("ご利用ありがとうございました🙇‍♀️")
            os.exit()
        end
    end
end

auth()
base = getLibBase(libName)
gg.alert("✅ パスワード認証成功\n\n更新日:2025.7.31日\n\nお知らせ͛📢\n\nスクリプトを使用する前にGGのアイコンを押し左上のツムツムアイコンの1つ右にあるバーマークを押しPtrace保護のためのバイパスモードを押し何も無いに変更してください")

while true do
    if gg.isVisible(true) then
        gg.setVisible(false)
        mainMenu()
    end
    gg.sleep(200)
end
