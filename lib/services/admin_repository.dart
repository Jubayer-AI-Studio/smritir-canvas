// =====================================================================
// 'স্মৃতির ক্যানভাস' (Smritir Canvas) — Full Admin Repository & Mutation Engine
// Spec-Kit & Superpowers Phase 2: Backend Logic
// সমস্ত বিষয়ের ওপর লেখকের সম্পূর্ণ এডিট, ডিলিট ও নিয়ন্ত্রণ ক্ষমতা
// =====================================================================

import '../models/models.dart';

class AdminRepository {
  // ১. প্রোফাইল সম্পূর্ণ এডিট ও আপডেট
  static AuthorProfile updateAuthorProfile({
    required AuthorProfile currentProfile,
    String? name,
    List<String>? titleBadges,
    String? avatarUrl,
    String? bio,
    String? whatsappNumber,
    String? facebookProfileUrl,
    String? facebookPageUrl,
    String? portalUrl,
    String? newSecretPassword,
    String? newVaultPin,
  }) {
    return AuthorProfile(
      id: currentProfile.id,
      name: name ?? currentProfile.name,
      titleBadges: titleBadges ?? currentProfile.titleBadges,
      avatarUrl: avatarUrl ?? currentProfile.avatarUrl,
      bio: bio ?? currentProfile.bio,
      secretPasswordHash: newSecretPassword ?? currentProfile.secretPasswordHash,
      vaultPinHash: newVaultPin ?? currentProfile.vaultPinHash,
      whatsappNumber: whatsappNumber ?? currentProfile.whatsappNumber,
      facebookProfileUrl: facebookProfileUrl ?? currentProfile.facebookProfileUrl,
      facebookPageUrl: facebookPageUrl ?? currentProfile.facebookPageUrl,
      portalUrl: portalUrl ?? currentProfile.portalUrl,
    );
  }

  // ২. ক্যাটাগরি সম্পূর্ণ এডিট ও ডিলিট
  static CategoryItem updateCategory({
    required CategoryItem category,
    String? newName,
    String? newSlug,
    String? newBengaliIndex,
    int? newSortOrder,
    String? newIcon,
    String? newColorHex,
    bool? isVaultOnly,
  }) {
    return CategoryItem(
      id: category.id,
      name: newName ?? category.name,
      slug: newSlug ?? category.slug,
      bengaliIndex: newBengaliIndex ?? category.bengaliIndex,
      sortOrder: newSortOrder ?? category.sortOrder,
      iconName: newIcon ?? category.iconName,
      colorHex: newColorHex ?? category.colorHex,
      isVaultOnly: isVaultOnly ?? category.isVaultOnly,
    );
  }

  // ৩. আর্টিকেল সম্পূর্ণ এডিট ও ডিলিট (শিরোনাম, উপশিরোনাম, বডি, ক্যাটাগরি, ক্রম, স্ট্যাটাস)
  static ArticleItem updateArticle({
    required ArticleItem article,
    String? newCategoryId,
    String? newTitle,
    String? newSubtitle,
    String? newContent,
    String? newExcerpt,
    String? newCoverImageUrl,
    int? newWordCount,
    int? newReadingTimeMinutes,
    String? newBengaliOrderTag,
    int? newCustomSortOrder,
    String? newStatus,
    bool? isVaultLocked,
    String? newAudioAttachmentUrl,
  }) {
    return ArticleItem(
      id: article.id,
      categoryId: newCategoryId ?? article.categoryId,
      title: newTitle ?? article.title,
      subtitle: newSubtitle ?? article.subtitle,
      content: newContent ?? article.content,
      excerpt: newExcerpt ?? article.excerpt,
      coverImageUrl: newCoverImageUrl ?? article.coverImageUrl,
      wordCount: newWordCount ?? article.wordCount,
      readingTimeMinutes: newReadingTimeMinutes ?? article.readingTimeMinutes,
      bengaliOrderTag: newBengaliOrderTag ?? article.bengaliOrderTag,
      customSortOrder: newCustomSortOrder ?? article.customSortOrder,
      status: newStatus ?? article.status,
      isVaultLocked: isVaultLocked ?? article.isVaultLocked,
      viewsCount: article.viewsCount,
      likesCount: article.likesCount,
      commentsCount: article.commentsCount,
      audioAttachmentUrl: newAudioAttachmentUrl ?? article.audioAttachmentUrl,
      createdAt: article.createdAt,
    );
  }

  // ৪. বুকশেলফ কিতাব সম্পূর্ণ এডিট (পৃষ্ঠা ট্র্যাকিং, স্ট্যাটাস, লেখকের ব্যক্তিগত নোট)
  static BookItem updateBook({
    required BookItem book,
    String? newTitle,
    String? newOriginalAuthor,
    String? newCoverImageUrl,
    String? newPdfFilePath,
    String? newReadingStatus,
    int? newCurrentPage,
    int? newTotalPages,
    String? newScholarNotes,
    int? newSortOrder,
  }) {
    return BookItem(
      id: book.id,
      title: newTitle ?? book.title,
      originalAuthor: newOriginalAuthor ?? book.originalAuthor,
      coverImageUrl: newCoverImageUrl ?? book.coverImageUrl,
      pdfFilePath: newPdfFilePath ?? book.pdfFilePath,
      readingStatus: newReadingStatus ?? book.readingStatus,
      currentPage: newCurrentPage ?? book.currentPage,
      totalPages: newTotalPages ?? book.totalPages,
      scholarNotes: newScholarNotes ?? book.scholarNotes,
      sortOrder: newSortOrder ?? book.sortOrder,
    );
  }

  // ৫. লিভিং বাণী সম্পূর্ণ এডিট ও সক্রিয়তা পরিবর্তন
  static LivingQuote updateQuote({
    required LivingQuote quote,
    String? newQuoteText,
    String? newReferenceSource,
    bool? isActive,
    int? newDisplayOrder,
  }) {
    return LivingQuote(
      id: quote.id,
      quoteText: newQuoteText ?? quote.quoteText,
      referenceSource: newReferenceSource ?? quote.referenceSource,
      isActive: isActive ?? quote.isActive,
      displayOrder: newDisplayOrder ?? quote.displayOrder,
    );
  }
}
