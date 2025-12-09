plugins {
    kotlin("jvm") version "2.0.21"
}

repositories {
    mavenCentral()
}

// Configure source sets to include all files that use the Java SDK
sourceSets {
    main {
        kotlin {
            include(
                "GenerateJwt.kt",
                "UpsertUser.kt",
                "GetUserProfile.kt",
                "CreateList.kt",
                "SendTemplateToUserId.kt",
                "SendTemplateToEmail.kt",
                "SendTemplateToList.kt",
                "SendTemplateToAudience.kt",
                "SendTemplateToTenant.kt",
                "SubscribeUserToList.kt",
                "UnsubscribeUserFromList.kt",
                "EnvLoader.kt"
            )
            setSrcDirs(listOf("."))
        }
        java {
            setSrcDirs(emptyList<String>()) // Disable Java compilation
        }
    }
}

dependencies {
    implementation("org.jetbrains.kotlin:kotlin-stdlib")
    
    // Jackson for JSON processing
    implementation("com.fasterxml.jackson.core:jackson-databind:2.15.2")
    
    // Courier Java SDK
    implementation("com.courier:courier-java:4.0.1")
}

tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile> {
    kotlinOptions.jvmTarget = "17" // Match available Java version
}

// Disable Java compilation entirely
tasks.named("compileJava") {
    enabled = false
}

// Task to print the runtime classpath (useful for run.sh script)
tasks.register("printClasspath") {
    doLast {
        println(sourceSets["main"].runtimeClasspath.asPath)
    }
}

