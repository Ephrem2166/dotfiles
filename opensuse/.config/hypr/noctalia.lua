local mainMod = "SUPER"
local launcher = "qs -c noctalia-shell ipc call launcher toggle"
local controlCenter = "qs -c noctalia-shell ipc call controlCenter toggle"
local settings = "qs -c noctalia-shell ipc call settings toggle"
local power = "qs -c noctalia-shell ipc call sessionMenu toggle"
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(launcher))
hl.bind(mainMod .. "+ ALT + C", hl.dsp.exec_cmd(controlCenter))
hl.bind(mainMod .. "+ ALT + S", hl.dsp.exec_cmd(settings))
hl.bind(mainMod .. "+ SHIFT + X", hl.dsp.exec_cmd(power))

-- bind = SUPER, SPACE, exec, $ipc launcher toggle
-- bind = SUPER, S, exec, $ipc controlCenter toggle
-- bind = SUPER, comma, exec, $ipc settings toggle
