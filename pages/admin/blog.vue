<template>
  <div class="min-h-screen bg-zinc-50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
      <div class="flex items-center justify-between mb-8">
        <div>
          <NuxtLink to="/admin" class="text-sm text-zinc-600 hover:text-zinc-900 mb-2 inline-block">
            &larr; Back to Dashboard
          </NuxtLink>
          <h1 class="text-4xl font-bold text-zinc-900">Blog posts</h1>
        </div>
        <button class="btn btn-primary" @click="openAddModal">
          <Plus :size="20" class="mr-2" />
          New post
        </button>
      </div>

      <div class="card mb-6">
        <div class="flex items-center gap-4">
          <div class="flex-1">
            <input
              v-model="searchQuery"
              type="text"
              placeholder="Search posts..."
              class="input"
            />
          </div>
          <button @click="fetchPosts" class="btn btn-secondary">
            <Search :size="20" />
          </button>
        </div>
      </div>

      <div v-if="loading" class="space-y-4">
        <div v-for="i in 5" :key="i" class="card animate-pulse">
          <div class="h-6 bg-zinc-200 rounded w-1/3 mb-2"></div>
          <div class="h-4 bg-zinc-200 rounded w-1/2"></div>
        </div>
      </div>

      <div v-else-if="posts.length === 0" class="card text-center py-12">
        <FileText :size="48" class="mx-auto text-zinc-400 mb-4" />
        <h2 class="text-2xl font-semibold text-zinc-900 mb-2">No posts yet</h2>
        <p class="text-zinc-600 mb-6">Share stories, guides and brand updates with your guests.</p>
      </div>

      <div v-else class="card overflow-hidden">
        <div class="overflow-x-auto">
          <table class="w-full">
            <thead class="bg-zinc-50 border-b border-zinc-200">
              <tr>
                <th class="px-6 py-3 text-left text-xs font-medium text-zinc-600 uppercase tracking-wider">
                  Title
                </th>
                <th class="px-6 py-3 text-left text-xs font-medium text-zinc-600 uppercase tracking-wider">
                  Status
                </th>
                <th class="px-6 py-3 text-left text-xs font-medium text-zinc-600 uppercase tracking-wider">
                  Published
                </th>
                <th class="px-6 py-3 text-right text-xs font-medium text-zinc-600 uppercase tracking-wider">
                  Actions
                </th>
              </tr>
            </thead>
            <tbody class="bg-white divide-y divide-zinc-200">
              <tr v-for="post in posts" :key="post.id" class="hover:bg-zinc-50">
                <td class="px-6 py-4">
                  <p class="font-medium text-zinc-900 line-clamp-1">{{ post.title }}</p>
                  <p class="text-xs text-zinc-500 line-clamp-1">/{{ post.slug }}</p>
                </td>
                <td class="px-6 py-4 text-sm">
                  <span
                    class="inline-flex items-center rounded-full px-2 py-1 text-xs font-medium"
                    :class="post.status === 'published' ? 'bg-green-100 text-green-800' : 'bg-zinc-100 text-zinc-800'"
                  >
                    {{ post.status }}
                  </span>
                </td>
                <td class="px-6 py-4 text-sm text-zinc-700">
                  {{ post.published_at ? formatDate(post.published_at) : '—' }}
                </td>
                <td class="px-6 py-4 text-right">
                  <button
                    class="text-zinc-600 hover:text-zinc-900 mr-2"
                    @click="openEditModal(post)"
                  >
                    <Edit2 :size="18" />
                  </button>
                  <button
                    class="text-zinc-600 hover:text-red-600"
                    @click="confirmDelete(post)"
                  >
                    <Trash2 :size="18" />
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- Add/Edit post modal -->
      <div
        v-if="showModal"
        class="fixed inset-0 z-40 flex items-center justify-center bg-black/40 px-4 sm:px-6 lg:px-8"
        role="dialog"
        aria-modal="true"
      >
        <div class="w-full max-w-3xl rounded-2xl bg-white p-6 shadow-2xl max-h-[90vh] overflow-y-auto">
          <div class="flex items-start justify-between mb-4">
            <div>
              <h2 class="text-xl font-semibold text-zinc-900 mb-1">
                {{ editingPost ? 'Edit post' : 'New post' }}
              </h2>
              <p class="text-sm text-zinc-600">
                Publish guides, pairings and brand stories to deepen the experience.
              </p>
            </div>
            <button
              type="button"
              class="rounded-full p-1.5 text-zinc-500 hover:bg-zinc-100 hover:text-zinc-900 focus:outline-none focus:ring-2 focus:ring-zinc-900"
              @click="closeModal"
              aria-label="Close"
            >
              <X :size="18" />
            </button>
          </div>

          <form class="space-y-4" @submit.prevent="savePost">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label class="block text-sm font-medium text-zinc-900 mb-1" for="title">Title</label>
                <input
                  id="title"
                  v-model="form.title"
                  type="text"
                  required
                  class="input"
                  placeholder="e.g. How to build a weeknight cellar"
                />
              </div>
              <div>
                <label class="block text-sm font-medium text-zinc-900 mb-1" for="slug">Slug</label>
                <input
                  id="slug"
                  v-model="form.slug"
                  type="text"
                  required
                  class="input"
                  placeholder="e.g. weeknight-cellar-guide"
                />
              </div>
            </div>

            <div>
              <label class="block text-sm font-medium text-zinc-900 mb-1" for="excerpt">Excerpt</label>
              <textarea
                id="excerpt"
                v-model="form.excerpt"
                rows="2"
                class="input"
                placeholder="Short teaser used on cards and previews."
              />
            </div>

            <div>
              <label class="block text-sm font-medium text-zinc-900 mb-1" for="cover">Cover image URL</label>
              <input
                id="cover"
                v-model="form.cover_image_url"
                type="text"
                class="input"
                placeholder="https://..."
              />
            </div>

            <div>
              <label class="block text-sm font-medium text-zinc-900 mb-1" for="tags">Tags</label>
              <input
                id="tags"
                v-model="form.tags"
                type="text"
                class="input font-mono"
                placeholder="Comma-separated tags, e.g. cellar,food-pairing"
              />
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label class="block text-sm font-medium text-zinc-900 mb-1" for="status">Status</label>
                <select id="status" v-model="form.status" class="input">
                  <option value="draft">Draft</option>
                  <option value="published">Published</option>
                </select>
              </div>
              <div>
                <label class="block text-sm font-medium text-zinc-900 mb-1" for="published_at">Published at</label>
                <input
                  id="published_at"
                  v-model="form.published_at"
                  type="datetime-local"
                  class="input"
                />
              </div>
            </div>

            <div>
              <label class="block text-sm font-medium text-zinc-900 mb-1" for="content">Content</label>
              <textarea
                id="content"
                v-model="form.content"
                rows="8"
                class="input font-mono"
                placeholder="Write your article in Markdown or rich text for now."
              />
            </div>

            <div class="flex items-center justify-end gap-3 pt-2">
              <button type="button" class="btn btn-secondary" @click="closeModal">
                Cancel
              </button>
              <button type="submit" class="btn btn-primary">
                {{ saving ? 'Saving…' : editingPost ? 'Save changes' : 'Create post' }}
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { Plus, Search, FileText, Edit2, Trash2, X } from 'lucide-vue-next'
import type { Database } from '~/types/database'

definePageMeta({
  middleware: 'admin'
})

type BlogPost = Database['public']['Tables']['blog_posts']['Row']

const supabase = useSupabase()

const loading = ref(true)
const saving = ref(false)
const posts = ref<BlogPost[]>([])
const searchQuery = ref('')
const showModal = ref(false)
const editingPost = ref<BlogPost | null>(null)

const form = reactive({
  title: '',
  slug: '',
  excerpt: '',
  cover_image_url: '',
  tags: '',
  status: 'draft' as 'draft' | 'published',
  published_at: '',
  content: ''
})

const fetchPosts = async () => {
  loading.value = true
  try {
    let query = supabase.from('blog_posts').select('*').order('created_at', { ascending: false })

    if (searchQuery.value) {
      query = query.ilike('title', `%${searchQuery.value}%`)
    }

    const { data, error } = await query

    if (error) throw error
    posts.value = data || []
  } catch (error) {
    console.error('Error fetching posts:', error)
  } finally {
    loading.value = false
  }
}

const resetForm = () => {
  form.title = ''
  form.slug = ''
  form.excerpt = ''
  form.cover_image_url = ''
  form.tags = ''
  form.status = 'draft'
  form.published_at = ''
  form.content = ''
}

const openAddModal = () => {
  editingPost.value = null
  resetForm()
  showModal.value = true
}

const openEditModal = (post: BlogPost) => {
  editingPost.value = post
  form.title = post.title
  form.slug = post.slug
  form.excerpt = post.excerpt || ''
  form.cover_image_url = post.cover_image_url || ''
  form.tags = (post.tags || []).join(',')
  form.status = post.status
  form.published_at = post.published_at ? post.published_at.slice(0, 16) : ''
  form.content = post.content || ''
  showModal.value = true
}

const closeModal = () => {
  showModal.value = false
}

const savePost = async () => {
  if (!form.title || !form.slug) return

  saving.value = true

  try {
    const payload: Partial<BlogPost> = {
      title: form.title,
      slug: form.slug,
      excerpt: form.excerpt || null,
      cover_image_url: form.cover_image_url || null,
      status: form.status,
      content: form.content || null,
      tags: form.tags
        .split(',')
        .map((t) => t.trim())
        .filter(Boolean)
    }

    if (form.published_at) {
      payload.published_at = new Date(form.published_at).toISOString()
    } else {
      payload.published_at = null
    }

    if (editingPost.value) {
      const { error } = await supabase
        .from('blog_posts')
        .update(payload)
        .eq('id', editingPost.value.id)

      if (error) throw error
    } else {
      const { error } = await supabase
        .from('blog_posts')
        .insert(payload)

      if (error) throw error
    }

    await fetchPosts()
    showModal.value = false
  } catch (error) {
    console.error('Error saving post:', error)
  } finally {
    saving.value = false
  }
}

const confirmDelete = async (post: BlogPost) => {
  if (!window.confirm(`Delete post "${post.title}"?`)) return

  try {
    const { error } = await supabase.from('blog_posts').delete().eq('id', post.id)
    if (error) throw error
    await fetchPosts()
  } catch (error) {
    console.error('Error deleting post:', error)
  }
}

const formatDate = (date: string) => {
  return new Date(date).toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric'
  })
}

onMounted(() => {
  fetchPosts()
})

useHead({
  title: 'Manage Blog - Admin - Flux',
  meta: [
    {
      name: 'description',
      content: 'Manage blog posts for Flux'
    }
  ]
})
</script>
