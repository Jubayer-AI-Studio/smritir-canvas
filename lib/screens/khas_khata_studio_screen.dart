// =====================================================================
// 'স্মৃতির ক্যানভাস' (Smritir Canvas) — Khas Khata Studio
// Distraction-Free Studio, Voice Typing, Interview Chapter Markers & Poster Maker
// =====================================================================

import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/audio_service.dart';
import '../theme/canvas_theme.dart';

class KhasKhataStudioScreen extends StatefulWidget {
  final Function(ArticleItem) onSaveDraft;

  const KhasKhataStudioScreen({Key? key, required this.onSaveDraft}) : super(key: key);

  @override
  State<KhasKhataStudioScreen> createState() => _KhasKhataStudioScreenState();
}

class _KhasKhataStudioScreenState extends State<KhasKhataStudioScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  
  int _wordCount = 0;
  int _readingTime = 1;
  bool _isVaultLocked = false;
  bool _isVoiceRecording = false;
  final List<AudioMarker> _recordedMarkers = [];

  @override
  void initState() {
    super.initState();
    _bodyController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {
      _wordCount = AudioStudioService.countBengaliWords(_bodyController.text);
      _readingTime = AudioStudioService.calculateReadingTime(_bodyController.text);
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _toggleVoiceRecording() {
    setState(() {
      _isVoiceRecording = !_isVoiceRecording;
      if (_isVoiceRecording) {
        AudioStudioService.startInterviewRecording();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🎙️ বাংলা ভয়েস লিসেনিং ও সাক্ষাৎকার অডিও রেকর্ডিং শুরু হয়েছে...'),
            backgroundColor: CanvasColors.deepGreenAccent,
          ),
        );
      } else {
        AudioStudioService.stopInterviewRecording();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('⏹️ রেকর্ডিং সমাপ্ত ও ড্রাফটে সেভ হয়েছে।'),
            backgroundColor: CanvasColors.surfaceEmerald,
          ),
        );
      }
    });
  }

  void _addInterviewMarker() {
    final marker = AudioStudioService.addChapterMarker(
      articleId: 'draft_${DateTime.now().millisecondsSinceEpoch}',
      audioUrl: 'recordings/interview_clip.m4a',
      markerLabel: 'চ্যাপ্টার মার্কার #${_recordedMarkers.length + 1}',
      transcribedBengaliText: 'গুরুত্বপূর্ণ বক্তব্যের সারাংশ...',
    );
    setState(() {
      _recordedMarkers.add(marker);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('📌 ${marker.markerLabel} যুক্ত হয়েছে (${marker.timestampSeconds}s)!'),
        backgroundColor: CanvasColors.goldPrimary,
      ),
    );
  }

  void _generateQuotePoster() {
    final selection = _bodyController.selection;
    String quoteText = '';
    if (selection.isValid && !selection.isCollapsed) {
      quoteText = _bodyController.text.substring(selection.start, selection.end);
    } else {
      quoteText = _bodyController.text.trim().isNotEmpty
          ? _bodyController.text.trim().substring(0, _bodyController.text.trim().length > 90 ? 90 : _bodyController.text.trim().length)
          : 'কলমের কালি ও সত্যের সাক্ষ্য কখনো মুছে যায় না—যখন তা নিখাদ ইখলাসের সাথে লেখা হয়।';
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: CanvasColors.surfaceEmerald,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: CanvasColors.glassBorder),
          ),
          title: const Text('ফেসবুক কোটেশন পোস্টার', style: TextStyle(color: CanvasColors.goldLight, fontSize: 16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const RadialGradient(
                    center: Alignment.topLeft,
                    radius: 1.2,
                    colors: [CanvasColors.deepGreenAccent, CanvasColors.darkCharcoal],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: CanvasColors.goldPrimary, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: CanvasColors.goldPrimary.withOpacity(0.25),
                      blurRadius: 18,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(Icons.format_quote_rounded, color: CanvasColors.goldPrimary, size: 36),
                    const SizedBox(height: 12),
                    Text(
                      '"$quoteText"',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: CanvasColors.textIvory,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Divider(color: CanvasColors.glassBorder),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: CanvasColors.goldPrimary,
                          child: Icon(Icons.auto_stories, color: Colors.black, size: 18),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'স্মৃতির ক্যানভাস',
                              style: TextStyle(
                                color: CanvasColors.goldNeonGlow,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              'সাংবাদিক (ourislam24.com) • শিক্ষক',
                              style: TextStyle(
                                color: CanvasColors.textMuted,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('বন্ধ করুন', style: TextStyle(color: CanvasColors.textMuted)),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: CanvasColors.goldPrimary,
                foregroundColor: Colors.black,
              ),
              icon: const Icon(Icons.download_rounded, size: 18),
              label: const Text('পোস্টার সেভ করুন'),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('✅ কোটেশন পোস্টারটি ফটো গ্যালারিতে সংরক্ষিত হয়েছে!'),
                    backgroundColor: CanvasColors.deepGreenAccent,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _saveArticle() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('অনুগ্রহ করে লেখার শিরোনাম দিন!')),
      );
      return;
    }

    final newDraft = ArticleItem(
      id: 'article_${DateTime.now().millisecondsSinceEpoch}',
      categoryId: 'cat_01',
      title: _titleController.text.trim(),
      content: _bodyController.text.trim(),
      wordCount: _wordCount,
      readingTimeMinutes: _readingTime,
      bengaliOrderTag: 'নতুন',
      status: 'published',
      isVaultLocked: _isVaultLocked,
      createdAt: DateTime.now(),
    );

    widget.onSaveDraft(newDraft);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('আলহামদুলিল্লাহ! লেখাটি খাস খাতা থেকে স্মৃতির ক্যানভাসে সংরক্ষিত হয়েছে।'),
        backgroundColor: CanvasColors.deepGreenAccent,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CanvasColors.darkCharcoal,
      appBar: AppBar(
        title: const Text('খাস খাতা • লেখক স্টুডিও'),
        actions: [
          IconButton(
            icon: Icon(
              _isVaultLocked ? Icons.lock : Icons.lock_open,
              color: _isVaultLocked ? Colors.redAccent : CanvasColors.textMuted,
            ),
            tooltip: 'প্রাইভেট ভল্ট লক',
            onPressed: () => setState(() => _isVaultLocked = !_isVaultLocked),
          ),
          IconButton(
            icon: const Icon(Icons.check_circle_rounded, color: CanvasColors.goldPrimary),
            tooltip: 'সংরক্ষণ করুন',
            onPressed: _saveArticle,
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: CanvasColors.surfaceEmerald,
          border: const Border(top: BorderSide(color: CanvasColors.glassBorder)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.text_fields_rounded, size: 16, color: CanvasColors.goldLight),
                const SizedBox(width: 6),
                Text(
                  '$_wordCount শব্দ • $_readingTime মি. পাঠ',
                  style: const TextStyle(color: CanvasColors.textIvory, fontSize: 12),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image_outlined, color: CanvasColors.goldPrimary),
                  tooltip: 'কোটেশন ফটো জেনারেটর',
                  onPressed: _generateQuotePoster,
                ),
                IconButton(
                  icon: const Icon(Icons.bookmark_add_outlined, color: CanvasColors.goldLight),
                  tooltip: 'ইন্টারভিউ চ্যাপ্টার মার্কার',
                  onPressed: _addInterviewMarker,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: _isVoiceRecording ? Colors.redAccent : CanvasColors.deepGreenAccent,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(_isVoiceRecording ? Icons.mic : Icons.mic_none, color: Colors.white, size: 20),
                    tooltip: 'বাংলা ভয়েস টাইপিং',
                    onPressed: _toggleVoiceRecording,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              style: const TextStyle(
                color: CanvasColors.textIvory,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                hintText: 'লেখার শিরোনাম...',
                hintStyle: TextStyle(color: CanvasColors.textSubtle, fontSize: 18),
                border: InputBorder.none,
              ),
            ),
            const Divider(color: CanvasColors.glassBorder),
            Expanded(
              child: TextField(
                controller: _bodyController,
                maxLines: null,
                expands: true,
                style: const TextStyle(
                  color: CanvasColors.textIvory,
                  fontSize: 16,
                  height: 1.6,
                ),
                decoration: const InputDecoration(
                  hintText: 'বিসমিল্লাহির রাহমানির রাহিম...\nএখানে আপনার গভীর চিন্তা, সীরাত পর্যবেক্ষণ বা কিতাবের পর্যালোচনা লিখুন...',
                  hintStyle: TextStyle(color: CanvasColors.textSubtle, fontSize: 15),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
