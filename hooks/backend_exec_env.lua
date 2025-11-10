function PLUGIN:BackendExecEnv(ctx)
    
    local MATLAB_HASH = ctx.version
    local install_path = ctx.install_path
    
    local sep = package.config:sub(1,1)
    local parent_path = install_path:match("^(.*)[/\\][^/\\]+$")   -- one up
    if parent_path then
        parent_path = parent_path:match("^(.*)[/\\][^/\\]+$")      -- two up
    end
    local new_install_path = parent_path .. sep .. MATLAB_HASH
    -- Your logic to set up environment variables
    -- Example: add bin directories to PATH
    
    return {
        env_vars = {
            {key = "PATH", value = new_install_path .. "/bin"}
        }
    }
end