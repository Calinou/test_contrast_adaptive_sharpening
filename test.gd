# Copyright © 2021 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.
extends Node3D

var previous_cas_intensity := 1.0
var sway_camera := true
var counter := 0.0


func _process(delta: float) -> void:
	counter += delta
	if sway_camera:
		$Camera3D.rotation.y = TAU * 0.75 + sin(counter) * 0.1


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_info"):
		$Info.visible = not $Info.visible

	if event.is_action_pressed("increase_cas_intensity"):
		get_viewport().sharpen_intensity = clamp(0.0, get_viewport().sharpen_intensity + 0.1, 1.0)
		update_cas_label()

	if event.is_action_pressed("decrease_cas_intensity"):
		get_viewport().sharpen_intensity = clamp(0.0, get_viewport().sharpen_intensity - 0.1, 1.0)
		update_cas_label()

	if event.is_action_pressed("toggle_fxaa"):
		get_viewport().screen_space_aa = (
			Viewport.SCREEN_SPACE_AA_FXAA if get_viewport().screen_space_aa == Viewport.SCREEN_SPACE_AA_DISABLED else Viewport.SCREEN_SPACE_AA_DISABLED
		)
		$FXAA.text = "FXAA: disabled" if get_viewport().screen_space_aa == Viewport.SCREEN_SPACE_AA_DISABLED else "FXAA: enabled"

	if event.is_action_pressed("toggle_cas"):
		if is_zero_approx(get_viewport().sharpen_intensity):
			get_viewport().sharpen_intensity = previous_cas_intensity
		else:
			previous_cas_intensity = get_viewport().sharpen_intensity
			get_viewport().sharpen_intensity = 0.0

		update_cas_label()

	if event.is_action_pressed("toggle_animation"):
		sway_camera = not sway_camera


func update_cas_label() -> void:
	if is_zero_approx(get_viewport().sharpen_intensity):
		$CASIntensity.text = "CAS: disabled"
	else:
		$CASIntensity.text = "CAS: enabled (intensity %s)" % str(get_viewport().sharpen_intensity).pad_decimals(1)
