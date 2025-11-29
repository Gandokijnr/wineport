<template>
  <div class="min-h-screen bg-zinc-50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
      <div class="flex items-center justify-between mb-8">
        <div>
          <NuxtLink to="/admin" class="text-sm text-zinc-600 hover:text-zinc-900 mb-2 inline-block">
            &larr; Back to Dashboard
          </NuxtLink>
          <h1 class="text-4xl font-bold text-zinc-900">Categories</h1>
        </div>
        <button class="btn btn-primary" @click="openAddModal">
          <Plus :size="20" class="mr-2" />
          Add Category
        </button>
      </div>

      <div class="card mb-6">
        <div class="flex items-center gap-4">
          <div class="flex-1">
            <input
              v-model="searchQuery"
              type="text"
              placeholder="Search categories..."
              class="input"
            />
          </div>
          <button @click="fetchCategories" class="btn btn-secondary">
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

      <div v-else-if="categories.length === 0" class="card text-center py-12">
        <Layers :size="48" class="mx-auto text-zinc-400 mb-4" />
        <h2 class="text-2xl font-semibold text-zinc-900 mb-2">No categories found</h2>
        <p class="text-zinc-600 mb-6">Start by adding your first category</p>
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
                  Slug
                </th>
                <th class="px-6 py-3 text-left text-xs font-medium text-zinc-600 uppercase tracking-wider">
                  Parent
                </th>
                <th class="px-6 py-3 text-left text-xs font-medium text-zinc-600 uppercase tracking-wider">
                  Sort Order
                </th>
                <th class="px-6 py-3 text-right text-xs font-medium text-zinc-600 uppercase tracking-wider">
                  Actions
                </th>
              </tr>
            </thead>
            <tbody class="bg-white divide-y divide-zinc-200">
              <tr v-for="category in categories" :key="category.id" class="hover:bg-zinc-50">
                <td class="px-6 py-4">
                  <p class="font-medium text-zinc-900">{{ category.name }}</p>
                  <p v-if="category.description" class="text-xs text-zinc-600 line-clamp-1">
                    {{ category.description }}
                  </p>
                </td>
                <td class="px-6 py-4 text-sm text-zinc-900 font-mono">
                  {{ category.slug }}
                </td>
                <td class="px-6 py-4 text-sm text-zinc-700">
                  {{ category.parent_id ? parentNameMap[category.parent_id] || '—' : '—' }}
                </td>
                <td class="px-6 py-4 text-sm text-zinc-900">
                  {{ category.sort_order ?? 0 }}
                </td>
                <td class="px-6 py-4 text-right">
                  <button class="text-zinc-600 hover:text-zinc-900 mr-2" @click="openEditModal(category)">
                    <Edit2 :size="18" />
                  </button>
                  <button class="text-zinc-600 hover:text-red-600" @click="confirmDelete(category)">
                    <Trash2 :size="18" />
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- Add / Edit modal -->
      <div
        v-if="showModal"
        class="fixed inset-0 z-40 flex items-center justify-center bg-black/40 px-4 sm:px-6 lg:px-8"
        role="dialog"
        aria-modal="true"
      >
        <div class="w-full max-w-lg rounded-2xl bg-white p-6 shadow-2xl">
          <div class="flex items-start justify-between mb-4">
            <div>
              <h2 class="text-xl font-semibold text-zinc-900 mb-1">
                {{ editingCategory ? 'Edit category' : 'Add category' }}
              </h2>
              <p class="text-sm text-zinc-600">
                Organise your catalog by creating clear, navigable categories.
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

          <form class="space-y-4" @submit.prevent="saveCategory">
            <div>
              <label class="block text-sm font-medium text-zinc-900 mb-1" for="name">Name</label>
              <input
                id="name"
                v-model="form.name"
                type="text"
                required
                class="input"
                placeholder="e.g. Red Wine"
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
                placeholder="e.g. red-wine"
              />
            </div>

            <div>
              <label class="block text-sm font-medium text-zinc-900 mb-1" for="description">Description</label>
              <textarea
                id="description"
                v-model="form.description"
                rows="3"
                class="input"
                placeholder="Short description used in navigation and SEO."
              />
            </div>

            <div>
              <label class="block text-sm font-medium text-zinc-900 mb-1" for="parent">Parent category</label>
              <select id="parent" v-model="form.parent_id" class="input">
                <option :value="null">No parent</option>
                <option
                  v-for="cat in parentOptions"
                  :key="cat.id"
                  :value="cat.id"
                >
                  {{ cat.name }}
                </option>
              </select>
            </div>

            <div>
              <label class="block text-sm font-medium text-zinc-900 mb-1" for="sort_order">Sort order</label>
              <input
                id="sort_order"
                v-model.number="form.sort_order"
                type="number"
                class="input"
                min="0"
              />
            </div>

            <div class="flex items-center justify-end gap-3 pt-2">
              <button type="button" class="btn btn-secondary" @click="closeModal">
                Cancel
              </button>
              <button type="submit" class="btn btn-primary">
                {{ saving ? 'Saving...' : 'Save category' }}
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { Layers, Plus, Search, Edit2, Trash2, X } from 'lucide-vue-next'
import type { Database } from '~/types/database'

definePageMeta({
  middleware: 'admin'
})

type Category = Database['public']['Tables']['categories']['Row']

type CategoryForm = {
  name: string
  slug: string
  description: string | null
  parent_id: string | null
  sort_order: number | null
}

const supabase = useSupabase()

const loading = ref(true)
const saving = ref(false)
const categories = ref<Category[]>([])
const searchQuery = ref('')
const showModal = ref(false)
const editingCategory = ref<Category | null>(null)
const form = reactive<CategoryForm>({
  name: '',
  slug: '',
  description: null,
  parent_id: null,
  sort_order: 0
})

const parentNameMap = reactive<Record<string, string>>({})

const parentOptions = computed(() => {
  return categories.value.filter(cat => !editingCategory.value || cat.id !== editingCategory.value.id)
})

const resetForm = () => {
  form.name = ''
  form.slug = ''
  form.description = null
  form.parent_id = null
  form.sort_order = 0
}

const openAddModal = () => {
  editingCategory.value = null
  resetForm()
  showModal.value = true
}

const openEditModal = (category: Category) => {
  editingCategory.value = category
  form.name = category.name
  form.slug = category.slug
  form.description = category.description
  form.parent_id = category.parent_id
  form.sort_order = category.sort_order ?? 0
  showModal.value = true
}

const closeModal = () => {
  showModal.value = false
}

const fetchCategories = async () => {
  loading.value = true
  try {
    let query = supabase.from('categories').select('*').order('sort_order', { ascending: true }).order('created_at', { ascending: true })

    if (searchQuery.value) {
      query = query.ilike('name', `%${searchQuery.value}%`)
    }

    const { data, error } = await query

    if (error) throw error

    categories.value = data || []

    const map: Record<string, string> = {}
    for (const cat of categories.value) {
      map[cat.id] = cat.name
    }
    Object.assign(parentNameMap, map)
  } catch (error) {
    console.error('Error fetching categories:', error)
  } finally {
    loading.value = false
  }
}

const saveCategory = async () => {
  try {
    saving.value = true

    if (!form.name || !form.slug) return

    if (editingCategory.value) {
      const { error } = await supabase
        .from('categories')
        .update({
          name: form.name,
          slug: form.slug,
          description: form.description,
          parent_id: form.parent_id,
          sort_order: form.sort_order ?? 0
        })
        .eq('id', editingCategory.value.id)

      if (error) throw error
    } else {
      const { error } = await supabase.from('categories').insert({
        name: form.name,
        slug: form.slug,
        description: form.description,
        parent_id: form.parent_id,
        sort_order: form.sort_order ?? 0
      })

      if (error) throw error
    }

    await fetchCategories()
    closeModal()
  } catch (error) {
    console.error('Error saving category:', error)
  } finally {
    saving.value = false
  }
}

const confirmDelete = async (category: Category) => {
  // Simple confirm for now; can be replaced with a nicer dialog later
  if (!window.confirm(`Delete category "${category.name}"?`)) return

  try {
    const { error } = await supabase.from('categories').delete().eq('id', category.id)
    if (error) throw error
    await fetchCategories()
  } catch (error) {
    console.error('Error deleting category:', error)
  }
}

onMounted(() => {
  fetchCategories()
})

useHead({
  title: 'Manage Categories - Admin - LiquidLogistics',
  meta: [
    {
      name: 'description',
      content: 'Manage categories in LiquidLogistics'
    }
  ]
})
</script>
