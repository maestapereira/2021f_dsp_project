#!/usr/bin/env python
# coding: utf-8

# Make confusion matrix plot

# In[ ]:


import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

tn = 12017454
fp = 131559

fn = 272144
tp = 424130

actual_neg = tn + fp # 12149013
actual_pos = tp + fn # 696274

predic_neg = tn + fn # 12289598
predic_pos = tp + fp # 555689


# In[28]:


# confusion matrix
cm = [[tn, fp], [fn, tp]]

fig, ax = plt.subplots(figsize=(15, 15))
# plot
shw = ax.imshow(cm, cmap='Blues')
ax.set_title('Confusion Matrix')
bar = plt.colorbar(shw)
# show plot with labels
plt.xlabel('Predicted label')
plt.ylabel('True label')
bar.set_label('accuracies')
plt.xticks(ticks=[0, 1], labels=['false', 'true'], rotation='vertical')
plt.yticks(ticks=[0, 1], labels=['false', 'true'])
plt.show()


# In[31]:


# confusion matrix normalized by actual data totals
cm_norm_by_actual = [[tn/actual_neg, fp/actual_pos], [fn/actual_neg, tp/actual_pos]]
fig, ax = plt.subplots(figsize=(15, 15))
# plot
shw = ax.imshow(conf_matrix_norm, cmap='Blues')
ax.set_title('Confusion Matrix: normalized by actual data')
bar = plt.colorbar(shw)
# show plot with labels
plt.xlabel('Predicted label')
plt.ylabel('True label')
bar.set_label('accuracies')
plt.xticks(ticks=[0, 1], labels=['false', 'true'], rotation='vertical')
plt.yticks(ticks=[0, 1], labels=['false', 'true'])
# set limits to 0 and 1
shw.set_clim(0, 1)
plt.show()


# In[33]:


# confusion matrix normalized by predicted data totals
cm_norm_by_pred = [[tn/predic_neg, fp/predic_pos], [fn/predic_neg, tp/predic_pos]]
fig, ax = plt.subplots(figsize=(15, 15))
# plot confusion matrix
shw = ax.imshow(cm_by_pred, cmap='Blues')
ax.set_title('Confusion Matrix: normalized by predicted data')
bar = plt.colorbar(shw)
# show plot with labels
plt.xlabel('Predicted label')
plt.ylabel('True label')
bar.set_label('accuracies')
plt.xticks(ticks=[0, 1], labels=['false', 'true'], rotation='vertical')
plt.yticks(ticks=[0, 1], labels=['false', 'true'])
# set limits to 0 and 1
shw.set_clim(0, 1)
plt.show()

