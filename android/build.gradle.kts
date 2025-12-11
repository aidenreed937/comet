import org.gradle.api.Action
import org.gradle.api.Task

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

subprojects {
    if (name == "flutter_secure_storage") {
        tasks.matching { task -> task.name.startsWith("lint", ignoreCase = true) }
            .configureEach(object : Action<Task> {
                override fun execute(task: Task) {
                    task.enabled = false
                }
            })
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
