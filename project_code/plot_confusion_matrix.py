#!/usr/bin/env python
# coding: utf-8

# Make confusion matrix plot

# In[ ]:


#### import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

tn = 12017454
fp = 131559

fn = 272144
tp = 424130

actual_neg = 12149013
actual_pos = 696274

predic_neg = 12289598
predic_pos = 555689


# In[22]:


conf_matrix = [[tn, fp], [fn, tp]]
conf_matrix


# In[21]:


conf_matrix_norm = [[tn/actual_neg, fp/actual_pos], [fn/actual_neg, tp/actual_pos]]
conf_matrix_norm


# In[26]:


conf_matrix_norm2 = [[tn/predic_neg, fp/predic_pos], [fn/predic_neg, tp/predic_pos]]
conf_matrix_norm2


# In[11]:


np.linspace(0, 2, 2)


# In[28]:


fig, ax = plt.subplots(figsize=(15, 15))
# plot confusion matrix
shw = ax.imshow(conf_matrix, cmap='Blues')
ax.set_title('Confusion Matrix')

bar = plt.colorbar(shw)
  
# show plot with labels
plt.xlabel('Predicted label')
plt.ylabel('True label')
bar.set_label('accuracies')
plt.xticks(ticks=[0, 1], labels=['false', 'true'], rotation='vertical')
plt.yticks(ticks=[0, 1], labels=['false', 'true'])

# shw.set_clim(0, 1)
plt.show()


# In[33]:


fig, ax = plt.subplots(figsize=(15, 15))
# plot confusion matrix
shw = ax.imshow(conf_matrix_norm2, cmap='Blues')
ax.set_title('Confusion Matrix: normalized by predicted data')

bar = plt.colorbar(shw)
  
# show plot with labels
plt.xlabel('Predicted label')
plt.ylabel('True label')
bar.set_label('accuracies')
plt.xticks(ticks=[0, 1], labels=['false', 'true'], rotation='vertical')
plt.yticks(ticks=[0, 1], labels=['false', 'true'])

shw.set_clim(0, 1)
plt.show()


# In[31]:


fig, ax = plt.subplots(figsize=(15, 15))
# plot confusion matrix
shw = ax.imshow(conf_matrix_norm, cmap='Blues')
ax.set_title('Confusion Matrix: normalized by actual data')

bar = plt.colorbar(shw)
  
# show plot with labels
plt.xlabel('Predicted label')
plt.ylabel('True label')
bar.set_label('accuracies')
plt.xticks(ticks=[0, 1], labels=['false', 'true'], rotation='vertical')
plt.yticks(ticks=[0, 1], labels=['false', 'true'])

shw.set_clim(0, 1)
plt.show()


# In[ ]:




