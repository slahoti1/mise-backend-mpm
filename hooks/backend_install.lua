function PLUGIN:BackendInstall(ctx)
    local tool = ctx.tool
    local version = ctx.version
    local install_path = ctx.install_path
    local mpm_url = ""

    -- Detect OS using path seperator
    local sep = package.config:sub(1,1)
    local os = ""
    if sep == "\\" then
        os = "windows"
    else
        local uname = io.open("uname"):read("*l")
        os = uname:lower()
    end
    
    -- Set URL based on OS
    if os:find("linux") then
        mpm_url = "https://www.mathworks.com/mpm/glnxa64/mpm"
    elseif os:find("darwin") or os:find("mac") then
        -- Default to Intel macOS
        mpm_url = "https://www.mathworks.com/mpm/maci64/mpm"
    else
        mpm_url = "https://www.mathworks.com/mpm/win64/mpm"
    end

    return {
        version = version
        -- url = mpm_url
    }
        
   local products = "MATLAB"
   products = products:gsub(",", " ")

   -- Set mpm path based on OS
   --local mpm_path = is_windows and [[C:\Users\slahoti\mpm.exe]] or "mpm"
   local mpm_path = "mpm"

   -- Build the install command
   local cmd = string.format('%s install --release=%s --destination=%s --products=%s', mpm_path, version, install_path, products)

   print("[DEBUG] Running: " .. cmd)

   local res = os.execute(cmd)
   if res ~= 0 then
       error("MATLAB install failed")
   end
end