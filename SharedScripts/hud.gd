extends CanvasLayer

func _ready() -> void:
    ScoreManager.score_updated.connect(_update_score)

func _update_score(new_score: int):
    $Label.text = "Score: " + str(new_score)
