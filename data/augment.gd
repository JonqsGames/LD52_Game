extends Resource
class_name Augment

enum AugmentType {
	ReelExtend,
	SpeedBoost,
	Repair,
	SteeringImprove
}

@export var beak_cost : int
@export var augment_name = ""
@export var image : Texture2D
@export_multiline  var description
@export var type : AugmentType
