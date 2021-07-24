extends Node2D

onready var _endTaskButton = $EndTaskButton
onready var _taskNameLineEdit = $TaskNameLineEdit

func _ready() -> void:
	pass

# Finds all tasks with the specified image name
# which is the executable name as it shows up in task manager.
func TerminateProcess(taskName):
	var output = []
	var error = OS.execute("tasklist", ["/fi", "imagename eq " + taskName, "/fo", "csv"], true, output)
	if error == 1:
		print("Failed to execute tasklist command!")
		return

	var taskListData : Array = output[0].split("\n", false)

	# Remove the headers
	taskListData.remove(0)

	if taskListData.empty():
		print("Did not find a matching task to terminate.")
		return

	for line in taskListData:
		var data = line.split(",")
		var pid = data[1]
		error = OS.execute("taskkill", ["/f", "/pid", pid], true)
		if error == 1:
			print("Failed to end task to pid: " + pid)
		else:
			print("Successfully ended task to pid: " + pid)

func _on_Button_pressed() -> void:
	if _taskNameLineEdit.text == "":
		OS.alert("Yo! Need to provide a task name first!")
		return

	TerminateProcess(_taskNameLineEdit.text)
