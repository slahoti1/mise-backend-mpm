function PLUGIN:BackendExecEnv(ctx)
    local install_path = ctx.install_path
    
    -- Your logic to set up environment variables
    -- Example: add bin directories to PATH
    
    return {
        env_vars = {
            {key = "PATH", value = install_path .. "/bin"}
        }
    }
end