import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(PictureStoryApp());
}

// ignore: use_key_in_widget_constructors
class PictureStoryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Picture Story Time',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StoryLibraryScreen(),
    );
  }
}

// ignore: use_key_in_widget_constructors
class StoryLibraryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers, unused_element
    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add New Story'),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Title'),
                  Text('Image'),
                  Text('Content'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Save'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Story Library'),
      ),
      body: ListView.builder(
        itemCount: storyList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Navigate to the story viewer screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      StoryViewerScreen(story: storyList[index]),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Image.asset(
                    storyList[index].coverImage,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 16.0),
                  Text(
                    storyList[index].title,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class StoryViewerScreen extends StatefulWidget {
  final Story story;

  StoryViewerScreen({super.key, required this.story});
  FlutterTts flutterTts = FlutterTts();

  @override
  State<StoryViewerScreen> createState() => _StoryViewerScreenState();
}

class _StoryViewerScreenState extends State<StoryViewerScreen> {
  bool playing = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.story.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              widget.story.coverImage,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.story.content,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            ElevatedButton(
              onPressed: () async{
                // Implement interactive elements or read-aloud functionality
                if (playing) {
                  await widget.flutterTts.pause();
                } else {
                  await widget.flutterTts.speak(widget.story.content);
                }
                setState(() {
                  playing = !playing;
                });
              },
              child: Text(playing ? 'Pause' : 'Read Aloud'),
            ),
          ],
        ),
      ),
    );
  }
}

class Story {
  final String title;
  final String coverImage;
  final String content;

  Story({required this.title, required this.coverImage, required this.content});
}

// Dummy data
List<Story> storyList = [
  Story(
      title: 'The boy who cried wolf',
      coverImage: 'assets/the boy and the wolf.png',
      content:
          'Once, there was a boy who became bored when he watched over the village sheep grazing on the hillside. To entertain himself, he sang out, Wolf! Wolf! The wolf is chasing the sheep!,When the villagers heard the cry, they came running up the hill to drive the wolf away. But, when they arrived, they saw no wolf. The boy was amused when seeing their angry faces.“Dont scream wolf, boy,” warned the villagers, “when there is no wolf!” They angrily went back down the hill.Later, the shepherd boy cried out once again, “Wolf! Wolf! The wolf is chasing the sheep!” To his amusement, he looked on as the villagers came running up the hill to scare the wolf away.As they saw there was no wolf, they said strictly, “Save your frightened cry for when there really is a wolf! Dont cry wolf when there is no wolf! But the boy grinned at their words while they walked grumbling down the hill once more.Later, the boy saw a real wolf sneaking around his flock. Alarmed, he jumped on his feet and cried out as loud as he could, Wolf! Wolf! But the villagers thought he was fooling them again, and so they didnt come to help.At sunset, the villagers went looking for the boy who hadnt returned with their sheep. When they went up the hill, they found him weeping.There really was a wolf here! The flock is gone! I cried out, Wolf! but you didnt come, he wailed. An old man went to comfort the boy. As he put his arm around him, he said, Nobody believes a liar, even when he is telling the truth!'
          ),
  // Add more stories here
  
  Story(
    title: 'Adlof Hitler',
    coverImage: '../assets/hitler.jpg',
    content:
      "Adolf Hitler, a key figure in 20th-century history, rose to power as Germany's Chancellor in 1933, capitalizing on crises like the Reichstag fire to consolidate authority.Under his leadership, the Nazi regime dismantled democracy, suppressed opposition, and pursued aggressive policies that led to World War II and the Holocaust, resulting in immense devastation and loss of life."
  ),

  Story(
    title: 'Genghis Khan',
    coverImage: '../assets/genghis.jpg',
    content:
    "Genghis Khan, a formidable Mongol leader born in the late 12th century, united diverse tribes into a potent empire through strategic military prowess and innovative tactics. His swift and vast conquests across Asia expanded the Mongol Empire, making it the largest contiguous land empire in history. Genghis Khan's legacy lies in his transformative impact on trade, culture, and governance, while his military achievements continue to be studied for their enduring influence.",
  ),
];
