#include <iostream>
#include <vector>

using namespace std;

struct TreeNode
{
    int val;
    TreeNode *left;
    TreeNode *right;
    explicit TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
};

void
deleteTree(TreeNode *root)
{
    if (root)
    {
        deleteTree(root->left);
        deleteTree(root->right);
        delete root;
    }
}

TreeNode *
sortedArrayToBST(vector<int> &nums, int start, int end)
{
    if (start > end)
        return nullptr;
    int mid = start + (end - start) / 2;
    auto *root = new TreeNode(nums[mid]);
    root->left = sortedArrayToBST(nums, start, mid - 1);
    root->right = sortedArrayToBST(nums, mid + 1, end);
    return root;
}

void
inorderPrint(TreeNode *root)
{
    if (root)
    {
        inorderPrint(root->left);
        cout << root->val << " ";
        inorderPrint(root->right);
    }
}

/*
// pb1
void
preorderPrint(TreeNode *root)
{
    if (root)
    {
        cout << root->val << " ";
        preorderPrint(root->left);
        preorderPrint(root->right);
    }
}

void
postorderPrint(TreeNode *root)
{
    if (root)
    {
        postorderPrint(root->left);
        postorderPrint(root->right);
        cout << root->val << " ";
    }
}

int
main()
{
    vector<int> sorted_array = {1, 2, 3, 4, 5, 6, 7, 8, 9};
    TreeNode *bst_root = sortedArrayToBST(sorted_array, 0, (int)sorted_array.size() - 1);
    inorderPrint(bst_root);
    cout << endl;
    preorderPrint(bst_root);
    cout << endl;
    postorderPrint(bst_root);
    deleteTree(bst_root);
    return 0;
}
*/


// pb 2
void inorderTraversal(TreeNode* root, vector<int>& result) {
    if (root == nullptr) return;
    inorderTraversal(root->left, result);
    result.push_back(root->val);
    inorderTraversal(root->right, result);
}

vector<int> mergeArrays(const vector<int>& arr1, const vector<int>& arr2) {
    vector<int> merged;
    int i = 0, j = 0;
    while (i < arr1.size() && j < arr2.size()) {
        if (arr1[i] < arr2[j]) {
            merged.push_back(arr1[i]);
            i++;
        } else {
            merged.push_back(arr2[j]);
            j++;
        }
    }
    while (i < arr1.size()) {
        merged.push_back(arr1[i]);
        i++;
    }
    while (j < arr2.size()) {
        merged.push_back(arr2[j]);
        j++;
    }
    return merged;
}

TreeNode* mergeTrees(TreeNode* root1, TreeNode* root2) {
    vector<int> array1, array2;
    inorderTraversal(root1, array1);
    inorderTraversal(root2, array2);
    vector<int> mergedArray = mergeArrays(array1, array2);
    return sortedArrayToBST(mergedArray, 0, (int)mergedArray.size() - 1);
}

int main() {
    auto* root1 = new TreeNode(3);
    root1->left = new TreeNode(1);
    root1->right = new TreeNode(5);
    auto* root2 = new TreeNode(4);
    root2->left = new TreeNode(2);
    root2->right = new TreeNode(6);
    TreeNode* mergedTree = mergeTrees(root1, root2);
    inorderPrint(mergedTree);
    cout << endl;
    deleteTree(root1);
    deleteTree(root2);
    return 0;
}
