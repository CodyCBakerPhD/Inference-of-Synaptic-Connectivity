
function Compare_EmpVsTheor_Discrim(SubTypeDiscrim,SubTypeTheorDiscrimFromTheorVals)
    
    lw = 2;
    ms = 10;
    fs = 16;
    
    Colors = {[0 0.6 0], ... % EE1
      [0 0.8 0], ... % EE2
      [0.3010 0.7450 0.9330], ... % IE
      [0.6 0 0], ... % II1
      [0.8 0 0], ... % II2
      [0.4940 0.1840 0.5560], ... % EI
      [0 0.4470 0.7410]}; % EIIE
    
    set(0,'defaulttextinterpreter','latex')
    figure
    plot(1,SubTypeDiscrim.EE1vsEE0, 'o', 'Linewidth',lw, 'MarkerSize',ms, 'Color',Colors{1})
    hold on
    plot(1,SubTypeTheorDiscrimFromTheorVals.EE1vsEE0, 'x', 'Linewidth',lw, 'MarkerSize',ms, ...
                                                                                  'Color',Colors{1})
    plot(2,SubTypeDiscrim.EE2vsEE0, 'o', 'Linewidth',lw, 'MarkerSize',ms, 'Color',Colors{2})
    plot(2,SubTypeTheorDiscrimFromTheorVals.EE2vsEE0, 'x', 'Linewidth',lw, 'MarkerSize',ms, ...
                                                                                  'Color',Colors{2})
    plot(3,SubTypeDiscrim.II1vsII0, 'o', 'Linewidth',lw, 'MarkerSize',ms, 'Color',Colors{4})
    plot(3,SubTypeTheorDiscrimFromTheorVals.II1vsII0, 'x', 'Linewidth',lw, 'MarkerSize',ms, ...
                                                                                  'Color',Colors{4})
    plot(4,SubTypeDiscrim.II2vsII0, 'o', 'Linewidth',lw, 'MarkerSize',ms, 'Color',Colors{5})
    plot(4,SubTypeTheorDiscrimFromTheorVals.II2vsII0, 'x', 'Linewidth',lw, 'MarkerSize',ms, ...
                                                                                  'Color',Colors{5})
    plot(5,SubTypeDiscrim.EIvsEIIE0, 'o', 'Linewidth',lw, 'MarkerSize',ms, 'Color',Colors{6})
    plot(5,SubTypeTheorDiscrimFromTheorVals.EIvsEIIE0, 'x', 'Linewidth',lw, 'MarkerSize',ms, ...
                                                                                  'Color',Colors{6})
    plot(6,SubTypeDiscrim.IEvsEIIE0, 'o', 'Linewidth',lw, 'MarkerSize',ms, 'Color',Colors{3})
    plot(6,SubTypeTheorDiscrimFromTheorVals.IEvsEIIE0, 'x', 'Linewidth',lw, 'MarkerSize',ms, ...
                                                                                  'Color',Colors{3})
    plot(7,SubTypeDiscrim.EIIEvsEIIE0, 'o', 'Linewidth',lw, 'MarkerSize',ms, 'Color',Colors{7})
    plot(7,SubTypeTheorDiscrimFromTheorVals.EIIEvsEIIE0, 'x', 'Linewidth',lw, 'MarkerSize',ms, ...
                                                                                  'Color',Colors{7})
    ylabel('Discriminability')
    box off
    set(gca,'LineWidth',lw)
    set(gca,'FontSize',fs)
    set(gca,'XTick',[1 2 3 4 5 6 7],'XTickLabel',{'EE1','EE2','II1','II2','EI','IE','EIIE'});
    axis([0.8 7.2 -Inf Inf])

end

