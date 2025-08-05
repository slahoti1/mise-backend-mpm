function PLUGIN:BackendInstall(ctx)
    local tool = ctx.tool
    local version = ctx.version
    local install_path = ctx.install_path

    local cmd = require("cmd")
    local sep = package.config:sub(1,1)
    local os = ""
    local os_type
    if sep == "\\" then
        os_type = "windows"
    else
        local uname = cmd.exec("uname -s"):lower()
        if uname:find("linux") then
            os_type = "linux"
        elseif uname:find("darwin") or uname:find("mac") then
            os_type = "darwin"
        else
            os_type = uname
        end
    end
   

    -- Compute parent directory
    local parent_path = install_path:match("^(.*)[/\\][^/\\]+$")
    if not parent_path then
        error("Could not determine parent_path from install_path: " .. tostring(install_path))
    end

    local mpm_exe
    if os_type == "windows" then
        mpm_exe = parent_path .. "\\mpm.exe"
    else
        mpm_exe = parent_path .. "/mpm"
    end

    local mpm_url = ""
    -- Check if mpm already exists
    local file = io.open(mpm_exe, "r")
    if file then
        file:close()
        -- Already present, do nothing
    else
        
        -- Download mpm in parent directory
        if  os_type == "linux" then
            mpm_url = "https://www.mathworks.com/mpm/glnxa64/mpm"
        
        elseif os_type == "windows" then
            mpm_url = "https://www.mathworks.com/mpm/win64/mpm"
        else
            -- Default to Intel macOS
            mpm_url = "https://www.mathworks.com/mpm/maci64/mpm"
        end
    

        local http = require("http")
        -- Download file
        local err = http.download_file({
            url = mpm_url,
            headers = {
                ['User-Agent'] = "mpm-download"
            }
        }, mpm_exe)

        if err ~= nil then
            error("Download failed: " .. err)
        end
    end

    if os_type ~= "windows" then
        cmd.exec('chmod +x "' .. mpm_exe .. '"')
    end
    
    local file = io.open(mpm_exe, "r")
    if file then
        print("[DEBUG] mpm.exe successfully downloaded at: " .. mpm_exe)
        file:close()
    else
        print("mpm.exe was not downloaded correctly to: " .. mpm_exe)
    end
    -- Prepare products
    local products = tool
    products = products:gsub(",", " ")

    -- Build the install command
    local matlab_cmd = string.format('%s install --release=%s --destination=%s --products=%s', mpm_exe, version, install_path, products)


    print("[DEBUG] Running: " .. matlab_cmd)

    local result = cmd.exec(matlab_cmd)
    

    return {}
end