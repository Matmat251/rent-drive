package capaEntidad;

import java.util.List;

/**
 * Clase que encapsula una lista paginada de resultados.
 * Proporciona toda la información necesaria para mostrar paginación en la UI.
 */
public class PaginatedResult<T> {

    private List<T> items;
    private int currentPage;
    private int pageSize;
    private int totalItems;
    private int totalPages;

    public PaginatedResult(List<T> items, int currentPage, int pageSize, int totalItems) {
        this.items = items;
        this.currentPage = currentPage;
        this.pageSize = pageSize;
        this.totalItems = totalItems;
        this.totalPages = (int) Math.ceil((double) totalItems / pageSize);
    }

    public List<T> getItems() {
        return items;
    }

    public int getCurrentPage() {
        return currentPage;
    }

    public int getPageSize() {
        return pageSize;
    }

    public int getTotalItems() {
        return totalItems;
    }

    public int getTotalPages() {
        return totalPages;
    }

    public boolean hasPreviousPage() {
        return currentPage > 1;
    }

    public boolean hasNextPage() {
        return currentPage < totalPages;
    }

    public int getPreviousPage() {
        return currentPage > 1 ? currentPage - 1 : 1;
    }

    public int getNextPage() {
        return currentPage < totalPages ? currentPage + 1 : totalPages;
    }

    public int getStartIndex() {
        return (currentPage - 1) * pageSize + 1;
    }

    public int getEndIndex() {
        int end = currentPage * pageSize;
        return Math.min(end, totalItems);
    }

    public int[] getPageNumbers(int maxVisible) {
        if (totalPages <= maxVisible) {
            int[] pages = new int[totalPages];
            for (int i = 0; i < totalPages; i++) {
                pages[i] = i + 1;
            }
            return pages;
        }

        int half = maxVisible / 2;
        int start = Math.max(1, currentPage - half);
        int end = Math.min(totalPages, start + maxVisible - 1);

        if (end - start < maxVisible - 1) {
            start = Math.max(1, end - maxVisible + 1);
        }

        int[] pages = new int[end - start + 1];
        for (int i = 0; i < pages.length; i++) {
            pages[i] = start + i;
        }
        return pages;
    }

    public boolean isEmpty() {
        return items == null || items.isEmpty();
    }

    public int getItemCount() {
        return items != null ? items.size() : 0;
    }
}
