--Minetest
--Copyright (C) 2013 sapier
--
--This program is free software; you can redistribute it and/or modify
--it under the terms of the GNU Lesser General Public License as published by
--the Free Software Foundation; either version 2.1 of the License, or
--(at your option) any later version.
--
--This program is distributed in the hope that it will be useful,
--but WITHOUT ANY WARRANTY; without even the implied warranty of
--MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--GNU Lesser General Public License for more details.
--
--You should have received a copy of the GNU Lesser General Public License along
--with this program; if not, write to the Free Software Foundation, Inc.,
--51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

--------------------------------------------------------------------------------

local function dlg_confirm_reset_formspec(data)
	local retval =
		"size[8,3]" ..
		"label[1,1;".. fgettext("Are you sure to reset your singleplayer world?") .. "]"..
		"button[1,2;2.6,0.5;dlg_reset_singleplayer_confirm;"..
				fgettext("Yes") .. "]" ..
		"button[4,2;2.8,0.5;dlg_reset_singleplayer_cancel;"..
				fgettext("No!!!") .. "]"
	return retval
end

local function dlg_confirm_reset_btnhandler(this, fields, dialogdata)

	if fields["dlg_reset_singleplayer_confirm"] ~= nil then

		local worldlist = core.get_worlds()
		local found_singleplayerworld = false

		for i=1,#worldlist,1 do
			if worldlist[i].name == "singleplayerworld" then
				found_singleplayerworld = true
				gamedata.worldindex = i
			end
		end

		if found_singleplayerworld then
			core.delete_world(gamedata.worldindex)
		end

		core.create_world("singleplayerworld", 1)

		worldlist = core.get_worlds()

		found_singleplayerworld = false

		for i=1,#worldlist,1 do
			if worldlist[i].name == "singleplayerworld" then
				found_singleplayerworld = true
				gamedata.worldindex = i
			end
		end
	end

	this.parent:show()
	this:hide()
	this:delete()
end

local function showconfirm_reset(tabview)
	local new_dlg = dialog_create("reset_spworld",
		dlg_confirm_reset_formspec,
		dlg_confirm_reset_btnhandler,
		nil,
		tabview)
	tabview:hide()
	new_dlg:show()
end



local function formspec(tabview, name, tabdata)
	local tab_string =
		"vertlabel[0,0;" .. fgettext("SETTINGS") .. "]" ..
		"box[0.75,0;3.25,4;#999999]" ..
		"checkbox[1,0;cb_fancy_trees;".. fgettext("Fancy Trees") .. ";"
				.. dump(core.setting_getbool("new_style_leaves")) .. "]"..
		"checkbox[1,0.5;cb_smooth_lighting;".. fgettext("Smooth Lighting")
				.. ";".. dump(core.setting_getbool("smooth_lighting")) .. "]"..
		"checkbox[1,1;cb_3d_clouds;".. fgettext("3D Clouds") .. ";"
				.. dump(core.setting_getbool("enable_3d_clouds")) .. "]"..
		"checkbox[1,1.5;cb_opaque_water;".. fgettext("Opaque Water") .. ";"
				.. dump(core.setting_getbool("opaque_water")) .. "]"..
		"checkbox[1,2.0;cb_pre_ivis;".. fgettext("Preload item visuals") .. ";"
				.. dump(core.setting_getbool("preload_item_visuals"))	.. "]"..
		"checkbox[1,2.5;cb_particles;".. fgettext("Enable Particles") .. ";"
				.. dump(core.setting_getbool("enable_particles"))	.. "]"..
		"checkbox[1,3.0;cb_finite_liquid;".. fgettext("Finite Liquid") .. ";"
				.. dump(core.setting_getbool("liquid_finite")) .. "]"..
		"box[4.25,0;3.25,2.5;#999999]" ..
		"checkbox[4.5,0;cb_mipmapping;".. fgettext("Mip-Mapping") .. ";"
				.. dump(core.setting_getbool("mip_map")) .. "]"..
		"checkbox[4.5,0.5;cb_anisotrophic;".. fgettext("Anisotropic Filtering") .. ";"
				.. dump(core.setting_getbool("anisotropic_filter")) .. "]"..
		"checkbox[4.5,1.0;cb_bilinear;".. fgettext("Bi-Linear Filtering") .. ";"
				.. dump(core.setting_getbool("bilinear_filter")) .. "]"..
		"checkbox[4.5,1.5;cb_trilinear;".. fgettext("Tri-Linear Filtering") .. ";"
				.. dump(core.setting_getbool("trilinear_filter")) .. "]"..
		"box[7.75,0;4,4;#999999]" ..
		"checkbox[8,0;cb_shaders;".. fgettext("Shaders") .. ";"
				.. dump(core.setting_getbool("enable_shaders")) .. "]"..
		"button[1,4.5;2.25,0.5;btn_change_keys;".. fgettext("Change keys") .. "]"
	
	local android = false
	if android then
		tab_string = tab_string ..
		"box[4.25,2.75;3.25,2.5;#999999]" ..
		"checkbox[4.5,2.75;cb_touchscreen_target;".. fgettext("Touch free target") .. ";"
				.. dump(core.setting_getbool("touchtarget")) .. "]" ..
		"button[8,4.5;3.75,0.5;btn_reset_singleplayer;".. fgettext("Reset singleplayer world") .. "]"
	end

	if core.setting_get("touchscreen_threshold") ~= nil then
		tab_string = tab_string ..
				"label[4.5,3.5;" .. fgettext("Touchthreshold (px)") .. "]" ..
				"dropdown[4.5,4;3;dd_touchthreshold;0,10,20,30,40,50;" ..
				((tonumber(core.setting_get("touchscreen_threshold"))/10)+1) .. "]"
	end

	if core.setting_getbool("enable_shaders") then
		tab_string = tab_string ..
				"checkbox[8,0.5;cb_bumpmapping;".. fgettext("Bumpmapping") .. ";"
						.. dump(core.setting_getbool("enable_bumpmapping")) .. "]"..
				"checkbox[8,1.0;cb_generate_normalmaps;".. fgettext("Generate Normalmaps") .. ";"
						.. dump(core.setting_getbool("generate_normalmaps")) .. "]"..
				"checkbox[8,1.5;cb_parallax;".. fgettext("Parallax Occlusion") .. ";"
						.. dump(core.setting_getbool("enable_parallax_occlusion")) .. "]"..
				"checkbox[8,2.0;cb_waving_water;".. fgettext("Waving Water") .. ";"
						.. dump(core.setting_getbool("enable_waving_water")) .. "]"..
				"checkbox[8,2.5;cb_waving_leaves;".. fgettext("Waving Leaves") .. ";"
						.. dump(core.setting_getbool("enable_waving_leaves")) .. "]"..
				"checkbox[8,3.0;cb_waving_plants;".. fgettext("Waving Plants") .. ";"
						.. dump(core.setting_getbool("enable_waving_plants")) .. "]"
	else
		tab_string = tab_string ..
				"textlist[8.33,0.7;4,1;;#888888" .. fgettext("Bumpmapping") .. ";0;true]" ..
				"textlist[8.33,1.2;4,1;;#888888" .. fgettext("Generate Normalmaps") .. ";0;true]" ..
				"textlist[8.33,1.7;4,1;;#888888" .. fgettext("Parallax Occlusion") .. ";0;true]" ..
				"textlist[8.33,2.2;4,1;;#888888" .. fgettext("Waving Water") .. ";0;true]" ..
				"textlist[8.33,2.7;4,1;;#888888" .. fgettext("Waving Leaves") .. ";0;true]" ..
				"textlist[8.33,3.2;4,1;;#888888" .. fgettext("Waving Plants") .. ";0;true]"
		end
	return tab_string
end

--------------------------------------------------------------------------------
local function handle_settings_buttons(this, fields, tabname, tabdata)
	if fields["cb_fancy_trees"] then
		core.setting_set("new_style_leaves", fields["cb_fancy_trees"])
		return true
	end
	if fields["cb_smooth_lighting"] then
		core.setting_set("smooth_lighting", fields["cb_smooth_lighting"])
		return true
	end
	if fields["cb_3d_clouds"] then
		core.setting_set("enable_3d_clouds", fields["cb_3d_clouds"])
		return true
	end
	if fields["cb_opaque_water"] then
		core.setting_set("opaque_water", fields["cb_opaque_water"])
		return true
	end
	if fields["cb_mipmapping"] then
		core.setting_set("mip_map", fields["cb_mipmapping"])
		return true
	end
	if fields["cb_anisotrophic"] then
		core.setting_set("anisotropic_filter", fields["cb_anisotrophic"])
		return true
	end
	if fields["cb_bilinear"] then
		core.setting_set("bilinear_filter", fields["cb_bilinear"])
		return true
	end
	if fields["cb_trilinear"] then
		core.setting_set("trilinear_filter", fields["cb_trilinear"])
		return true
	end
	if fields["cb_shaders"] then
		if (core.setting_get("video_driver") == "direct3d8" or core.setting_get("video_driver") == "direct3d9") then
			core.setting_set("enable_shaders", "false")
			gamedata.errormessage = fgettext("To enable shaders the OpenGL driver needs to be used.")
		else
			core.setting_set("enable_shaders", fields["cb_shaders"])
		end
		return true
	end
	if fields["cb_pre_ivis"] then
		core.setting_set("preload_item_visuals", fields["cb_pre_ivis"])
		return true
	end
	if fields["cb_particles"] then
		core.setting_set("enable_particles", fields["cb_particles"])
		return true
	end
	if fields["cb_finite_liquid"] then
		core.setting_set("liquid_finite", fields["cb_finite_liquid"])
		return true
	end
	if fields["cb_bumpmapping"] then
		core.setting_set("enable_bumpmapping", fields["cb_bumpmapping"])
	end
	if fields["cb_generate_normalmaps"] then
		core.setting_set("generate_normalmaps", fields["cb_generate_normalmaps"])
	end
	if fields["cb_parallax"] then
		core.setting_set("enable_parallax_occlusion", fields["cb_parallax"])
		return true
	end
	if fields["cb_waving_water"] then
		core.setting_set("enable_waving_water", fields["cb_waving_water"])
		return true
	end
	if fields["cb_waving_leaves"] then
		core.setting_set("enable_waving_leaves", fields["cb_waving_leaves"])
	end
	if fields["cb_waving_plants"] then
		core.setting_set("enable_waving_plants", fields["cb_waving_plants"])
		return true
	end
	if fields["btn_change_keys"] ~= nil then
		core.show_keys_menu()
		return true
	end
	if fields["cb_touchscreen_target"] then
		core.setting_set("touchtarget", fields["cb_touchscreen_target"])
		return true
	end
	if fields["dd_touchthreshold"] then
		core.setting_set("touchscreen_threshold",fields["dd_touchthreshold"])
		return true
	end
	if fields["btn_reset_singleplayer"] then
		showconfirm_reset(this)
		return true
	end
end

tab_settings = {
	name = "settings",
	caption = fgettext("Settings"),
	cbf_formspec = formspec,
	cbf_button_handler = handle_settings_buttons
	}