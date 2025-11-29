<template>
  <div class="min-h-screen bg-zinc-50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
      <div class="flex items-center justify-between mb-8">
        <div>
          <NuxtLink to="/admin" class="text-sm text-zinc-600 hover:text-zinc-900 mb-2 inline-block">
            &larr; Back to Dashboard
          </NuxtLink>
          <h1 class="text-4xl font-bold text-zinc-900">Testimonials</h1>
        </div>
        <button class="btn btn-primary" @click="openAddModal">
          <Plus :size="20" class="mr-2" />
          New testimonial
        </button>
      </div>

      <div class="card mb-6">
        <div class="flex items-center gap-4">
          <div class="flex-1">
            <input
              v-model="searchQuery"
              type="text"
              placeholder="Search by name or quote..."
              class="input"
            />
          </div>
          <button @click="fetchTestimonials" class="btn btn-secondary">
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

      <div v-else-if="items.length === 0" class="card text-center py-12">
        <Quote :size="48" class="mx-auto text-zinc-400 mb-4" />
        <h2 class="text-2xl font-semibold text-zinc-900 mb-2">No testimonials yet</h2>
        <p class="text-zinc-600 mb-6">Highlight guest and partner experiences to build trust.</p>
      </div>

      <div v-else class="card overflow-hidden">
        <div class="overflow-x-auto">
          <table class="w-full">
            <thead class="bg-zinc-50 border-b border-zinc-200">
              <tr>
                <th class="px-6 py-3 text-left text-xs font-medium text-zinc-600 uppercase tracking-wider">
                  Name
                </th>
                <th class="px-6 py-3 text-left text-xs font-medium text-zinc-600 uppercase tracking-wider">
                  Quote
                </th>
                <th class="px-6 py-3 text-left text-xs font-medium text-zinc-600 uppercase tracking-wider">
                  Rating
                </th>
                <th class="px-6 py-3 text-left text-xs font-medium text-zinc-600 uppercase tracking-wider">
                  Flags
                </th>
                <th class="px-6 py-3 text-right text-xs font-medium text-zinc-600 uppercase tracking-wider">
                  Actions
                </th>
              </tr>
            </thead>
            <tbody class="bg-white divide-y divide-zinc-200">
              <tr v-for="t in items" :key="t.id" class="hover:bg-zinc-50">
                <td class="px-6 py-4 text-sm text-zinc-900">
                  <p class="font-medium">{{ t.author_name }}</p>
                  <p v-if="t.author_title" class="text-xs text-zinc-500">{{ t.author_title }}</p>
                </td>
                <td class="px-6 py-4 text-sm text-zinc-700">
                  <p class="line-clamp-2">“{{ t.quote }}”</p>
                </td>
                <td class="px-6 py-4 text-sm text-zinc-900">
                  <span v-if="t.rating" class="inline-flex items-center gap-1">
                    <Star class="text-amber-400 fill-amber-400" :size="14" />
                    <span>{{ t.rating }}/5</span>
                  </span>
                  <span v-else class="text-xs text-zinc-400">—</span>
                </td>
                <td class="px-6 py-4 text-sm text-zinc-900">
                  <div class="flex flex-wrap gap-2">
                    <span
                      v-if="t.is_featured"
                      class="inline-flex items-center rounded-full bg-indigo-50 text-indigo-700 px-2 py-0.5 text-xs font-medium"
                    >
                      Featured
                    </span>
                    <span
                      v-if="t.is_approved"
                      class="inline-flex items-center rounded-full bg-green-50 text-green-700 px-2 py-0.5 text-xs font-medium"
                    >
                      Approved
                    </span>
                    <span
                      v-else
                      class="inline-flex items-center rounded-full bg-zinc-50 text-zinc-700 px-2 py-0.5 text-xs font-medium"
                    >
                      Pending
                    </span>
                  </div>
                </td>
                <td class="px-6 py-4 text-right">
                  <button
                    class="text-zinc-600 hover:text-zinc-900 mr-2"
                    @click="openEditModal(t)"
                  >
                    <Edit2 :size="18" />
                  </button>
                  <button
                    class="text-zinc-600 hover:text-red-600"
                    @click="confirmDelete(t)"
                  >
                    <Trash2 :size="18" />
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- Add / Edit testimonial modal -->
      <div
        v-if="showModal"
        class="fixed inset-0 z-40 flex items-center justify-center bg-black/40 px-4 sm:px-6 lg:px-8"
        role="dialog"
        aria-modal="true"
      >
        <div class="w-full max-w-xl rounded-2xl bg-white p-6 shadow-2xl max-h-[90vh] overflow-y-auto">
          <div class="flex items-start justify-between mb-4">
            <div>
              <h2 class="text-xl font-semibold text-zinc-900 mb-1">
                {{ editing ? 'Edit testimonial' : 'New testimonial' }}
              </h2>
              <p class="text-sm text-zinc-600">
                Capture short quotes from collectors, sommeliers and partners.
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

          <form class="space-y-4" @submit.prevent="saveTestimonial">
            <div>
              <label class="block text-sm font-medium text-zinc-900 mb-1" for="name">Name</label>
              <input
                id="name"
                v-model="form.author_name"
                type="text"
                required
                class="input"
                placeholder="Name of the guest or partner"
              />
            </div>

            <div>
              <label class="block text-sm font-medium text-zinc-900 mb-1" for="title">Title / role</label>
              <input
                id="title"
                v-model="form.author_title"
                type="text"
                class="input"
                placeholder="e.g. Private collector, London"
              />
            </div>

            <div>
              <label class="block text-sm font-medium text-zinc-900 mb-1" for="quote">Quote</label>
              <textarea
                id="quote"
                v-model="form.quote"
                rows="4"
                required
                class="input"
                placeholder="Short quote in their own words."
              />
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label class="block text-sm font-medium text-zinc-900 mb-1" for="rating">Rating (optional)</label>
                <input
                  id="rating"
                  v-model.number="form.rating"
                  type="number"
                  min="1"
                  max="5"
                  class="input"
                  placeholder="1–5"
                />
              </div>
              <div class="flex items-center gap-4 pt-6">
                <label class="inline-flex items-center gap-2 text-sm text-zinc-900">
                  <input
                    v-model="form.is_featured"
                    type="checkbox"
                    class="rounded border-zinc-300 text-zinc-900 focus:ring-zinc-900"
                  />
                  <span>Featured</span>
                </label>
                <label class="inline-flex items-center gap-2 text-sm text-zinc-900">
                  <input
                    v-model="form.is_approved"
                    type="checkbox"
                    class="rounded border-zinc-300 text-zinc-900 focus:ring-zinc-900"
                  />
                  <span>Approved</span>
                </label>
              </div>
            </div>

            <div class="flex items-center justify-end gap-3 pt-2">
              <button type="button" class="btn btn-secondary" @click="closeModal">
                Cancel
              </button>
              <button type="submit" class="btn btn-primary">
                {{ saving ? 'Saving…' : editing ? 'Save changes' : 'Create testimonial' }}
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { Plus, Search, Quote, Edit2, Trash2, X, Star } from 'lucide-vue-next'
import type { Database } from '~/types/database'

definePageMeta({
  middleware: 'admin'
})

type Testimonial = Database['public']['Tables']['testimonials']['Row']

const supabase = useSupabase()

const loading = ref(true)
const saving = ref(false)
const items = ref<Testimonial[]>([])
const searchQuery = ref('')
const showModal = ref(false)
const editing = ref<Testimonial | null>(null)

const form = reactive({
  author_name: '',
  author_title: '',
  quote: '',
  rating: null as number | null,
  is_featured: false,
  is_approved: false
})

const fetchTestimonials = async () => {
  loading.value = true
  try {
    let query = supabase.from('testimonials').select('*').order('created_at', { ascending: false })

    if (searchQuery.value) {
      query = query.or(
        `author_name.ilike.%${searchQuery.value}%,quote.ilike.%${searchQuery.value}%`
      ) as any
    }

    const { data, error } = await query

    if (error) throw error
    items.value = data || []
  } catch (error) {
    console.error('Error fetching testimonials:', error)
  } finally {
    loading.value = false
  }
}

const resetForm = () => {
  form.author_name = ''
  form.author_title = ''
  form.quote = ''
  form.rating = null
  form.is_featured = false
  form.is_approved = false
}

const openAddModal = () => {
  editing.value = null
  resetForm()
  showModal.value = true
}

const openEditModal = (t: Testimonial) => {
  editing.value = t
  form.author_name = t.author_name
  form.author_title = t.author_title || ''
  form.quote = t.quote
  form.rating = t.rating ?? null
  form.is_featured = t.is_featured
  form.is_approved = t.is_approved
  showModal.value = true
}

const closeModal = () => {
  showModal.value = false
}

const saveTestimonial = async () => {
  if (!form.author_name || !form.quote) return

  saving.value = true

  try {
    const payload: Partial<Testimonial> = {
      author_name: form.author_name,
      author_title: form.author_title || null,
      quote: form.quote,
      rating: form.rating ?? null,
      is_featured: form.is_featured,
      is_approved: form.is_approved
    }

    if (editing.value) {
      const { error } = await supabase
        .from('testimonials')
        .update(payload)
        .eq('id', editing.value.id)

      if (error) throw error
    } else {
      const { error } = await supabase
        .from('testimonials')
        .insert(payload)

      if (error) throw error
    }

    await fetchTestimonials()
    showModal.value = false
  } catch (error) {
    console.error('Error saving testimonial:', error)
  } finally {
    saving.value = false
  }
}

const confirmDelete = async (t: Testimonial) => {
  if (!window.confirm(`Delete testimonial from "${t.author_name}"?`)) return

  try {
    const { error } = await supabase.from('testimonials').delete().eq('id', t.id)
    if (error) throw error
    await fetchTestimonials()
  } catch (error) {
    console.error('Error deleting testimonial:', error)
  }
}

onMounted(() => {
  fetchTestimonials()
})

useHead({
  title: 'Manage Testimonials - Admin - Flux',
  meta: [
    {
      name: 'description',
      content: 'Manage testimonials for Flux'
    }
  ]
})
</script>
