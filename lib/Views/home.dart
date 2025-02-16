import 'package:flutter/material.dart';
import 'package:mobile/Views/artworkviewer.dart';
import 'package:mobile/JSON/users.dart';
import 'package:mobile/Views/profile.dart';
import 'package:mobile/Views/gallery.dart';


class HomeScreen extends StatefulWidget {
  final Users? profile;
  const HomeScreen({super.key, this.profile});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //Our controllers
  //Controller is used to take the value from user and pass it to database
final TextEditingController bodyTemperatureController = TextEditingController();
  final TextEditingController heartRateController = TextEditingController();
  final TextEditingController bloodPressureController = TextEditingController();
  final TextEditingController oxygenSaturationController = TextEditingController();

  String? errorMessage;
  int moodScore = 5;
  String currentFeeling = "Neutral";
  String currentEnergy = "Moderate";

  final List<String> feelings = ["Happy", "Sad", "Angry", "Excited", "Neutral"];
  final List<String> energyLevels = ["Low", "Moderate", "High"];

  String moodScoreFeedback(int score) {
    if (score <= 3) {
      return "Don't worry, better days are ahead! 😞";
    } else if (score <= 6) {
      return "You're doing okay, keep pushing forward! 😐";
    } else {
      return "Fantastic! Keep up the great mood! 😄";
    }
  }

  Color moodScoreColor(int score) {
    if (score <= 3) {
      return Colors.red;
    } else if (score <= 6) {
      return Colors.yellow;
    } else {
      return Colors.green;
    }
  }

  String? feedbackMessageForCombination(String feeling, String energy) {
    if (feeling == "Happy" && energy == "High") {
      return "You're in a great mood and full of energy! Perfect time to tackle big tasks! 🌟";
    } else if (feeling == "Sad" && energy == "Low") {
      return "Take some time for self-care and reach out to a loved one. 💛";
    } else if (feeling == "Angry" && energy == "High") {
      return "Channel your energy into something constructive like a workout! 💪";
    }
    return null;
  }

  bool validateInputs() {
    if (bodyTemperatureController.text.isEmpty ||
        heartRateController.text.isEmpty ||
        bloodPressureController.text.isEmpty ||
        oxygenSaturationController.text.isEmpty) {
      setState(() {
        errorMessage = "Please fill out all fields.";
      });
      return false;
    }

    final temp = double.tryParse(bodyTemperatureController.text);
    if (temp == null || temp < 35.0 || temp > 42.0) {
      setState(() {
        errorMessage = "Body Temperature must be between 35°C and 42°C.";
      });
      return false;
    }

    final rate = int.tryParse(heartRateController.text);
    if (rate == null || rate < 40 || rate > 180) {
      setState(() {
        errorMessage = "Heart Rate must be between 40 BPM and 180 BPM.";
      });
      return false;
    }

    if (!RegExp(r'^\d{2,3}/\d{2,3}\$').hasMatch(bloodPressureController.text)) {
      return true;
      setState(() {
        errorMessage = "Blood Pressure must be in the format 120/80.";
      });
      return false;
    }

    final oxygen = int.tryParse(oxygenSaturationController.text);
    if (oxygen == null || oxygen < 80 || oxygen > 100) {
      setState(() {
        errorMessage = "Oxygen Saturation must be between 80% and 100%.";
      });
      return false;
    }

    setState(() {
      errorMessage = null;
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Health Data for ${widget.profile?.fullName ?? 'Guest'}"),
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.favorite), text: "Health Data"),
                Tab(icon: Icon(Icons.photo), text: "Gallery"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: bodyTemperatureController,
                      decoration: const InputDecoration(
                        labelText: "Body Temperature (°C)",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: heartRateController,
                      decoration: const InputDecoration(
                        labelText: "Heart Rate (BPM)",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: bloodPressureController,
                      decoration: const InputDecoration(
                        labelText: "Blood Pressure (e.g., 120/80)",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: oxygenSaturationController,
                      decoration: const InputDecoration(
                        labelText: "Oxygen Saturation (%)",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    Text("Mood Score: $moodScore", style: const TextStyle(fontSize: 18)),
                    Slider(
                      value: moodScore.toDouble(),
                      min: 1,
                      max: 10,
                      divisions: 9,
                      label: moodScore.toString(),
                      onChanged: (value) {
                        setState(() {
                          moodScore = value.toInt();
                        });
                      },
                    ),
                    Text(moodScoreFeedback(moodScore),
                        style: TextStyle(color: moodScoreColor(moodScore))),
                    const SizedBox(height: 20),
                    DropdownButton<String>(
                      value: currentFeeling,
                      isExpanded: true,
                      items: feelings
                          .map((feeling) => DropdownMenuItem(
                             value: feeling,
                            child: Text(feeling),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          currentFeeling = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    DropdownButton<String>(
                      value: currentEnergy,
                      isExpanded: true,
                      items: energyLevels
                          .map((energy) => DropdownMenuItem(
                               value: energy,
                               child: Text(energy),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          currentEnergy = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    if (errorMessage != null)
                      Text(
                        errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (validateInputs()) 
                        {
                          String bodyTemp = bodyTemperatureController.text;
                          int bodyTempNumber = int.parse(bodyTemp);
                          String imageName = 'assets/artworks/hr$bodyTemp.jpg';
                          Navigator.push
                              (
                                context,
                                MaterialPageRoute(builder: (context) => ImageViewScreen(imageName: imageName, bodyTemp: bodyTempNumber, profile: widget.profile)),
                              );
                        }
                      },
                      child: const Text("Create Artwork"),
                    ),
                  ],
                ),
              ),
               GalleryScreen(usrId: widget.profile?.usrId ?? 0),
            ],
          ),
        ),
      ),
    );
  }
}
