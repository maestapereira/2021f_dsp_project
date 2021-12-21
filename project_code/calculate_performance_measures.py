#!/usr/bin/env python
# coding: utf-8

# Calculate sensitivity, specificity, precision, negative predictive value and accuracy

# In[7]:


import numpy as np

tn = 12017454
fp = 131559

fn = 272144
tp = 424130

actual_neg = tn + fp
actual_pos = tp + fn

predic_neg = tn + fn
predic_pos = tp + fp

# calculate measures
sensitivity = tp / (tp + fn) # tp / actual_pos
specificity = tn / (tn + fp) # tn / actual_neg
precision = tp / (tp + fp) # tp / predic_pos
neg_pred_value = tn / (tn + fn) # tn / predic_neg

accuracy = (tp + tn) / (actual_pos + actual_neg) # or (tp + tn) / (predic_pos + predic_neg)

print(f'The sensitivity rate is {sensitivity}.')
print(f'The specificity rate is {specificity}.')
print(f'The precision rate is {precision}.')
print(f'The negative predictive value is {neg_pred_value}.')

print(f'The accuracy rate is {accuracy}.')


# In[ ]:




